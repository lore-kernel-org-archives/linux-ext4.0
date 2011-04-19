From: Jim Meyering <jim@meyering.net>
Subject: loopback-mounted ext4 sees hole-filling (on rawhide, but not F15)
Date: Tue, 19 Apr 2011 18:16:43 +0200
Message-ID: <87mxjmz05w.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain
To: ext <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:36505 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1DSQQv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Apr 2011 12:16:51 -0400
Received: from mx.meyering.net (unknown [82.230.74.64])
	by smtp1-g21.free.fr (Postfix) with ESMTP id BC4129401F3
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 18:16:44 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When I run the following script on rawhide (2.6.39-0.rc3.git2.0.fc16.x86_64)
it shows that a file with holes sometimes ends up with some non-NUL bytes
where the holes should be.

For best results, run it in an empty directory, preferably on a tmpfs FS.
I've run it on ext4, too.

It creates a 4MB ext4 file system, mounts it, and writes two files,
one with holes, the other identical, but with NULs instead,
and then runs sync, compares the two files, and unmounts
and removes the temporary file and the mount point directory.

The key is that it unlinks the backing file after mounting
and before writing the files.

=====================================
#!/bin/sh
set -e
dd if=/dev/zero of=blob bs=4k count=1000 >/dev/null 2>&1
mkdir mnt
mkfs -q -t ext4 -F blob
mount -oloop blob mnt

# Removing the backing file is key.
rm -f blob
cwd=$PWD
cd mnt

# Create a reference file.  Just like the following one,
# but with explicit NULs in place of holes.
perl -e '$n=1024; for (1..71) { print "\0"x$n, chr($_)x$n };' \
  -e 'close *STDOUT or die "$!"' > ref

# Seek 1KB, write 1KB of data, seek 1KB, write 1KB of data, etc....
perl -e '$n = 1 * 1024; *F = *STDOUT;' \
  -e 'for (1..71) { sysseek (*F, $n, 1)' \
  -e '&& syswrite (*F, chr($_)x$n) or die "$!"}' > j1

# filefrag -vs j1

sync
cmp -s ref j1 && fail=0 || { cmp -l ref j1|head -20; fail=1; }

cd /; umount "$cwd/mnt"
rm -rf "$cwd/blob" "$cwd/mnt"

exit $fail
=====================================

Interestingly, if you remove the "sync", it exits 0 every time.

Beware that sometimes you (accidentally?) get
all NUL blocks, so the script does occasionally exit 0.
To demonstrate, I turned off the cmp -l ...|head bit and ran it
for a while, printing only exit status:

    $ while :; do /t/loop-bug; printf $?; done
    110101111111111111111111111111101111110111111111111111101111111110101111101^C
    [Exit 130 (INT)]

Jim

P.S., this all started because I accidentally removed a backing
file, and that made some in-progress FIEMAP-related tests fail.

PPS, here's sample output, when it exits nonzero:

  # bash /t/bug-demo                                                    :
       9   0  41
      17   0 240
      18   0 216
      19   0 125
      20   0   1
      29   0   3
      30   0   3
      31   0   3
      32   0   3
      33   0 142
      34   0  40
      35   0 155
      36   0 156
      37   0 164
      39   0 142
      41   0  41
      49   0 146
      50   0 141
      51   0 151
      52   0 154
