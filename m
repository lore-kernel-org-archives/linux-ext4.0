From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Mon, 19 May 2008 13:16:26 -0400
Message-ID: <200805191316.27551.chris.mason@oracle.com>
References: <482DDA56.6000301@redhat.com> <4830E60A.2010809@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rXbMIGYghK3AhRZ"
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:60748 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbYESRSF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 May 2008 13:18:05 -0400
In-Reply-To: <20080518211140.b29bee30.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Boundary-00=_rXbMIGYghK3AhRZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 19 May 2008, Andrew Morton wrote:
> On Sun, 18 May 2008 21:29:30 -0500 Eric Sandeen <sandeen@redhat.com> wrote:
> > Theodore Tso wrote:
> > ...
> >
> > > Given how rarely people have reported problems, I think it's a really
> > > good idea to understand what exactly our exposure is for
> > > $COMMON_HARDWARE.
> >
> > I'll propose that very close to 0% of users will ever report "having
> > barriers off seems to have corrupted my disk on power loss!" even if
> > that's exactly what happened.  And it'd be very tricky to identify in a
> > post-mortem.  Instead we'd probably see other weird things caught down
> > the road during some later fsck or during filesystem use, and then
> > suggest that they go check their cables, run memtest86 or something...
> >
> > Perhaps it's not the intent of this reply, Ted, but various other bits
> > of this thread have struck me as trying to rationalize away the problem.
>
> Not really.  It's a matter of understanding how big the problem is.  We
> know what the cost of the solution is, and it's really large.
>
> It's a tradeoff, and it is unobvious where the ideal answer lies,
> especially when not all the information is available.

I think one mistake we (myself included) have made all along with the barrier 
code is intermixing discussions about the cost of the solution with 
discussions about needing barriers at all.  Everyone thinks the barriers are 
slow because we also think running without barriers is mostly safe.

Barriers are actually really fast, at least when you compare them to running 
with the writecache off.  Making them faster in general may be possible, but 
they are somewhat pushed off to the side right now because so few people are 
running them.

Here's a test workload that corrupts ext3 50% of the time on power fail 
testing for me.  The machine in this test is my poor dell desktop (3ghz, dual 
core, 2GB of ram), and the power controller is me walking over and ripping 
the plug out the back.

In other words, this is not a big automated setup doing randomized power fails 
on 64 nodes over 16 hours and many TB of data.  The data working set for this 
script is 32MB, and it takes about 10 minutes per run.

 The workload has 4 parts:

1) A directory tree full of empty files with very long names (160 chars)
2) A process hogging a significant percent of system ram.  This must  be
    enough to force constant metadata writeback due to memory pressure, and is
    controlled with -p size_in_mb
3) A process constantly writing, fsyncing and truncating to zero a single 64k
    file
4) A process constantly renaming the files with very long names from (1)
    between long-named-file.0 and long-named-file.1

The idea was to simulate a loaded mailserver, and to find the corruptions by 
reading through the directory tree and finding files long-named-file.0 and 
long-named-file.1 existing at the same time.  In practice, it is faster to 
just run fsck -f on the FS after a crash.

In order to consistently cause corruptions, the size of the directory from
(1) needs to be at least as large as the ext3 log.  This is controlled with
the -s command line option.  Smaller sizes may work for the impatient, but it 
is more likely to corrupt for larger ones.

The program first creates the files in a directory called barrier-test
then it starts procs to pin ram and run the constant fsyncs.  After
each phase has run long enough, they print out a statement about
being ready, along with some other debugging output:

Memory pin ready
fsyncs ready
Renames ready

Example run:

# make 500,000 inodes on a 2GB partition.  The results in a 32MB log
mkfs.ext3 -N 500000 /dev/sda2
mount /dev/sda2 /mnt
cd /mnt

# my machine has 2GB of ram, -s 1500 will pin ~1.5GB
barrier-test -s 32 -p 1500

Run init, don't cut the power yet
10000 files 1 MB total
 ... these lines repeat for a bit
200000 files 30 MB total
Starting metadata operations now
r:1000
Memory pin ready
f:100 r:2000 f:200 r:3000 f:300
fsyncs ready
r:4000 f:400 r:5000 f:500 r:6000 f:600 r:7000 f:700 r:8000 f:800 r:9000 f:900 
r:10000
Renames ready

# I pulled the plug here
# After boot:

root@opti:~# fsck -f /dev/sda2
fsck 1.40.8 (13-Mar-2008)
e2fsck 1.40.8 (13-Mar-2008)
/dev/sda2: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Problem in HTREE directory inode 281377 (/barrier-test): bad block number 
13543.
Clear HTree index<y>?    

< 246 other errors are here >

-chris

--Boundary-00=_rXbMIGYghK3AhRZ
Content-Type: application/x-python;
  name="barrier-test"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="barrier-test"

#!/usr/bin/env python
#
# This is a test program meant to heavily exercise log and metadata
# writeback.  If you combine this with power failures, it should result
# in filesystem corruptions a significant percent of the time.
#
# The workload has 4 parts:
#
# 1) A directory tree full of empty files with very long names (240 chars)
# 2) A process hogging a significant percent of system ram.  This must
#    be enough to force constant metadata writeback due to memory pressure
# 3) A process constantly writing, fsyncing and truncating to zero a single 64k
#    file
# 4) A process constantly renaming the files with very long names from (1) 
#    between long-named-file.0 and long-named-file.1
#
# In order to consistently cause corruptions, the size of the directory from
# (1) needs to be at least as large as the ext3 log.  This is controlled with
# the -s command line option
#
# The amount of memory pinned down is controlled with -p
#
# Usage:
# The program first creates the files in a directory called barrier-test
# then it starts procs to pin ram and run the constant fsyncs.  After
# each phase has run long enough, they print out a statement about
# being ready, along with some other debugging output:
#
# Memory pin ready
# fsyncs ready
# Renames ready
#
# Once you see all three ready lines, turn off power.  Don't use the
# power button on the front of the machine, either pull the plug, use
# the power switch on the back of the machine, or use an external controller
#
# Written by Chris Mason <chris.mason@oracle.com>

import sys, os, sha, random, mmap
from optparse import OptionParser

total_name_bytes = 0
counter = 0
errors = 0
sha = sha.new()
salt = file("/dev/urandom").read(256)
sha.update(salt)

def read_files(basedir, base_names):
    global total_name_bytes
    global counter
    global errors

    for x in os.listdir(basedir):
        total_name_bytes += len(x)
        counter += 1

        full = os.path.join(basedir, x)
        if not full.endswith(".0") and not full.endswith(".1"):
            continue
        num = int(x[-1])
        short = x[0:-2]
        if short in base_names:
            sys.stderr.write("warning: conflict on %s first %d dup %d\n" %
                            (short[0:10], base_names[short], num))
            errors += 1
        else:
            base_names[short] = num

def create_files(sha, basedir, base_names, size):
    global total_name_bytes
    global counter

    while total_name_bytes < size:
        s = str(counter)
        counter += 1

        sha.update(s)
        s = sha.hexdigest() * 4
        total_name_bytes += len(s)
        base_names[s] = 0
        fp = file(os.path.join(basedir, s + ".0"), 'w')
        fp.close()
        if counter % 10000 == 0:
            print "%d files %d MB total" % (counter,
                                            total_name_bytes / (1024 * 1024))

def run_fsyncs(basedir):
    pid = os.fork()
    if pid:
        os.waitpid(pid, os.WNOHANG)
        return
    fp = file(os.path.join(basedir, "bigfile"), 'w')
    buf = "a" * (64 * 1024)
    operations = 0
    while True:
        fp.write(buf)
        os.fsync(fp.fileno())
        fp.truncate(0)
        fp.seek(0)
        operations += 1
        if operations % 100 == 0:
            sys.stderr.write("f:%d " % operations)
            if operations == 300:
                sys.stderr.write("\nfsyncs ready\n")

def run_hog(hogmb):
    pid = os.fork()
    if pid:
        os.waitpid(pid, os.WNOHANG)
        return

    fp = file("/dev/zero", 'w+')
    hogmb *= 1024 * 1024
    mm = mmap.mmap(fp.fileno(), hogmb, mmap.MAP_PRIVATE,
                   mmap.PROT_READ | mmap.PROT_WRITE)
    operations = 0
    pos = 0
    didprint = 0
    buf = 'b' * 1024 * 1024
    while True:
        mm.write(buf)
        if mm.tell() >= hogmb:
            mm.seek(0)
            pos = 0
            operations += 1
            if not didprint:
                sys.stderr.write("\nMemory pin ready\n")
                didprint = 1

def run_renames(basedir, base_names):
    keys = base_names.keys()
    operations = 0
    while True:
        name = random.choice(keys)
        num = base_names[name]
        next = (num + 1) % 2
        os.rename(os.path.join(basedir, name + "." + str(num)),
                  os.path.join(basedir, name + "." + str(next)))
        base_names[name] = next
        operations += 1
        if operations % 1000 == 0:
            sys.stderr.write("r:%d " % operations)
            if operations == 10000:
                sys.stderr.write("\nRenames ready\n")

        
base_names = {}
usage = "usage: %prog [options]"
parser = OptionParser(usage=usage)
parser.add_option("-i", "--init", help="Init directory", default=False,
                  action="store_true")
parser.add_option("-d", "--dir", help="working dir", default="barrier-test")
parser.add_option("-s", "--size", help="Working set in MB",
                  type="int", default=32)
parser.add_option("-c", "--check", help="Check directory only",
                  default=False, action="store_true")
parser.add_option("-p", "--pin-mb", help="Amount of ram (MB) to pin",
                  default=512, type="int")
(options, args) = parser.parse_args()

sys.stderr.write("Run init, don't cut the power yet\n")
if not os.path.exists(options.dir):
    os.makedirs(options.dir, 0700)
    options.init = True
else:
    read_files(options.dir, base_names)
    print "found %d files %d MB in %s" % (counter,
                                          total_name_bytes / (1024 * 1024),
                                          options.dir)
options.size *= 1024 * 1024
if options.check:
    print "Check complete found %d errors" % errors
    if errors:
        sys.exit(1)
    else:
        sys.exit(0)

if total_name_bytes < options.size:
    create_files(sha, options.dir, base_names, options.size)
    
sys.stderr.write("Starting metadata operations now\n")
run_fsyncs(options.dir)
run_hog(options.pin_mb)
run_renames(options.dir, base_names)

--Boundary-00=_rXbMIGYghK3AhRZ--
