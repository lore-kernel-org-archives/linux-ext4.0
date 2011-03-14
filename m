From: Phillip Susi <psusi@cfl.rr.com>
Subject: Large directories and poor order correlation
Date: Mon, 14 Mar 2011 16:24:48 -0400
Message-ID: <4D7E7990.90209@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070507080107050002070900"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:39170 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab1CNUYw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2011 16:24:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070507080107050002070900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Shouldn't copying or extracting or otherwise populating a large
directory of many small files at the same time result in a strong
correlation between the order the names appear in the directory, and the
order their data blocks are stored on disk, and thus, read performance
should not be negatively impacted by fragmentation?

Background:

While migrating a server to a new system, I noticed that it was taking
forever to rsync my Maildir.  It seemed to be due to very low disk
throughput due to seeking.  I confirmed this with timing tests using
both tar and dump to /dev/zero to test reading the files after dropping
cache.  I noticed that tar was horribly slow, and dump was much better.
I surmise that this was due to poor correlation between the order of
file names in the directory and their data blocks on disk.  I would
expect this on an old fs that has grown slowly over a few years, and
that this would mostly go away after copying the files to a new system.
I found some surprises.  The big one being that after copying the files
to the new system, they still have a poor correlation between directory
and inode order.

Details:

The old system was a single disk with sequential throughput of 51 mb/s,
and the new one is a 4 disk raid-5 with sequential throughput of 160 mb/s.

On the old system, tar took 30 minutes, and dump took 8 minutes.  On the
new system, tar took 18 minutes, and dump took a mere 30 seconds!

On just the linux-kernel Maildir, which has 85,364 files taking up 660M
of space, dump on the old system clocks in at 11m41s and only 10s on the
new system.

I wrote a python script to actually measure the correlation between name
and inode order, inode and data block order, and name to data block
order.  It enumerates the files and counts it as being either in or out
of order by comparing the inode number to the last.  I expected to see a
much better correlation on the new system, but I did not.

On the new system the linux-kernel Maildir gets these results:

Name to inode correlation: 0.50002342908
Name to block correlation: 0.49996485638
Inode to block correlation: 0.889239023476

And on the old system:

Name to inode correlation: 0.499531418397
Name to block correlation: 0.499554847477
Inode to block correlation: 0.987418583946

The other folders get similar results.  You can see that the inode to
block correlation is improved, but it wasn't very bad to begin with so
going from 8 minutes to 30 seconds seems to be a good deal more
improvement than this would explain.  What concerns me though, is the
name to inode correlation went from terrible to slightly worse, which is
why tar still is horribly slow.

Attaching the script for reference.


--------------070507080107050002070900
Content-Type: text/x-python;
 name="correlation.py"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="correlation.py"

#!/usr/bin/python

import os
from stat import *
import fcntl
import array

names = os.listdir('.')
lastino = 0
name_to_ino_in = 0
name_to_ino_out = 0
lastblock = 0
name_to_block_in = 0
name_to_block_out = 0
iblocks = list()
inode_to_block_in = 0
inode_to_block_out = 0

for file in names :
    try :
        st = os.stat(file)
    except OSError:
        continue
    if not S_ISREG(st.st_mode) :
        continue
    if st.st_ino > lastino :
        name_to_ino_in += 1
    else : name_to_ino_out += 1
    lastino = st.st_ino    
    f = open(file)
    buf = array.array('I', [0])
    err = fcntl.ioctl(f.fileno(), 1, buf)
    if err != 0 :
        print "ioctl failed on " + f
    block = buf[0]
    if block != 0 :
        if block > lastblock :
            name_to_block_in += 1
        else : name_to_block_out += 1
        lastblock = block
        iblocks.append((st.st_ino,block))
print "Name to inode correlation: " + str(float(name_to_ino_in) / float((name_to_ino_in + name_to_ino_out)))
print "Name to block correlation: " + str(float(name_to_block_in) / float((name_to_block_in + name_to_block_out)))
iblocks.sort()
lastblock = 0
for i in iblocks:
    if i[1] > lastblock:
        inode_to_block_in += 1
    else: inode_to_block_out += 1
    lastblock = i[1]
print "Inode to block correlation: " + str(float(inode_to_block_in) / float((inode_to_block_in + inode_to_block_out)))

--------------070507080107050002070900--
