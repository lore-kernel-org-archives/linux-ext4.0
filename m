From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15579] ext4 -o discard produces incorrect blocks of zeroes in
 newly created files under heavy read+truncate+append-new-file load
Date: Mon, 29 Mar 2010 08:37:09 GMT
Message-ID: <201003290837.o2T8b9px016191@demeter.kernel.org>
References: <bug-15579-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58190 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab0C2IhL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Mar 2010 04:37:11 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2T8b9Gm016193
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 08:37:10 GMT
In-Reply-To: <bug-15579-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15579





--- Comment #9 from Andreas Beckmann <kernel-bugs@abeckmann.de>  2010-03-29 08:36:38 ---
(In reply to comment #4)
> Just for what it's worth, I've had trouble reproducing this on another brand of
> SSD... something like this (don't let the xfs_io throw you; it's just a
> convenient way to generate the IO).  I did this on a 512M filesystem.

With some small modifications I can reproduce this every time: I do two
iterations of truncating + writing the output. Seems to happen in the second
write only.
You can skip the reading, not neccessary.
N=236 ist the smallest N where the problem occurs, N=253 the maximum number of
files fitting on the file system.

./find-zeroes is my tool to check for "0x00 holes"

mkfs options: -m 0 -T largefile4

#!/bin/bash

SCRATCH_MNT=/mnt/scratch

N=253

#rm -f $SCRATCH_MNT/*
#touch $SCRATCH_MNT/outputfile
#xfs_io -F -c "pwrite 0 ${N}m" $SCRATCH_MNT/outputfile &>/dev/null
#xfs_io -F -c "pwrite ${N}M ${N}m" $SCRATCH_MNT/outputfile &>/dev/null
#./find-zeroes $SCRATCH_MNT/outputfile

rm -f $SCRATCH_MNT/*
touch $SCRATCH_MNT/outputfile

# Create several large-ish files
for I in `seq 1 $N`; do
  xfs_io -F -f -c "pwrite 0 2m" $SCRATCH_MNT/file$I &>/dev/null
done

# reread the last bit of each, just for kicks, and truncate off 1m
for I in `seq 1 $N`; do
  xfs_io -F -c "pread 1m 1m" $SCRATCH_MNT/file$I &>/dev/null
  xfs_io -F -c "truncate 1m" $SCRATCH_MNT/file$I
done

# Append the outputfile
xfs_io -F -c "pwrite 0 ${N}m" $SCRATCH_MNT/outputfile &>/dev/null

# reread the last bit of each, just for kicks, and truncate off 1m
for I in `seq 1 $N`; do
  xfs_io -F -c "pread 0m 1m" $SCRATCH_MNT/file$I &>/dev/null
  xfs_io -F -c "truncate 0m" $SCRATCH_MNT/file$I
done

# Append the outputfile
xfs_io -F -c "pwrite ${N}M ${N}m" $SCRATCH_MNT/outputfile &>/dev/null

./find-zeroes $SCRATCH_MNT/outputfile



$ ./trash-ext4-discard
at 246800384 length 18489344
size 511950848 zeroes 18489344
$ ./trash-ext4-discard
at 246808576 length 18481152
size 511950848 zeroes 18481152
$ ./trash-ext4-discard
at 246857728 length 18432000
size 511848448 zeroes 18432000
$ ./trash-ext4-discard
at 246640640 length 18649088
size 512086016 zeroes 18649088
$ ./trash-ext4-discard
at 246800384 length 18489344
size 511959040 zeroes 18489344

actually this is enough:


# Create several large-ish files
for I in `seq 1 $N`; do
  xfs_io -F -f -c "pwrite 0 1m" $SCRATCH_MNT/file$I &>/dev/null
done

# Append the outputfile
xfs_io -F -c "pwrite 0 ${N}m" $SCRATCH_MNT/outputfile &>/dev/null

# truncate all
for I in `seq 1 $N`; do
  xfs_io -F -c "truncate 0m" $SCRATCH_MNT/file$I
done

# Append the outputfile
xfs_io -F -c "pwrite ${N}M ${N}m" $SCRATCH_MNT/outputfile &>/dev/null


$ ./trash-ext4-discard2
at 228061184 length 37228544
size 530579456 zeroes 37228544

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
