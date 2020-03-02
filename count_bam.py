import subprocess
import sys
import re

class Read():

    def __init__(self, qname, flag, rname, start, mapq, cigar, mrnm, mpos, tlen, seq):

        self.qname = qname
        self.flag  = flag
        self.rname = rname
        self.start = start
        self.mapq  = mapq
        self.cigar = cigar
        self.mrnm  = mrnm
        self.mpos  = mpos
        self.tlen  = tlen        # insert size
        self.seq   = seq

    def isize(self):
        return abs(self.tlen)

    def __repr__(self):
        
        return "<Read %s (%s): %d/%d (%s)>" % (self.qname, "first" if self.first_in_pair() else "second", self.start, self.tlen, self.strand())

    def overlap(self, beg, end):

        pos = self.start
        for cl, ct in re.findall(r'(\d+)([A-Z]+)', self.cigar):

            clen = int(cl)
            if ct == "M":
                if pos+clen >= beg and pos <= end:
                    return True

            if ct in ["M", 'N', 'D']:
                pos += clen

        return False


if __name__ == "__main__":
    bamfile = sys.argv[1]
    m = re.match(r'(\S+):(\d+)-(\d+)', sys.argv[2])
    chrm = m.group(1)
    beg = int(m.group(2))
    end = int(m.group(3))
    p = subprocess.Popen(['samtools', 'view', '-F', '512', bamfile, '%s:%d-%d' % (chrm, beg, end)] , stdout=subprocess.PIPE)
    for line in p.stdout:
        qname, flag, rname, pos, mapq, cigar, mrnm, mpos, tlen, seq, _=line.strip().split(None, 10)
        read = Read(qname, int(flag), rname, int(pos), mapq, cigar, mrnm, int(mpos), int(tlen), seq)
        if read.overlap(beg, end):
            print line.strip()
