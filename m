From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: mdadm software raid + ext4, capped at ~350MiB/s limitation/bug?
Date: Sat, 27 Feb 2010 08:47:48 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002270840410.27192@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Alan Piszcz <ap@solarrain.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:60275 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968320Ab0B0Nru (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Feb 2010 08:47:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have two separate systems and with ext4 I cannot get speeds greater than 
~350MiB/s when using ext4 as the filesystem on top of a raid5 or raid0. 
It appears to be a bug with ext4 (or its just that ext4 is slower for this
test)?

Each system runs 2.6.33 x86_64.

Can someone please confirm?

Here is ext4:

# dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 29.8556 s, 360 MB/s

The result is the same regardless of the RAID type (RAID-5 or RAID-0)

Note, this is not a bandwidth problem:

# dd if=/dev/zero of=/dev/md0 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 17.6871 s, 607 MB/s

With XFS:

p63:~# mkfs.xfs -f /dev/md0
p63:~# mount /dev/md0 /r1
p63:~# cd /r1
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 17.6078 s, 610 MB/s

NOTE: With a HW raid controller (OR using XFS), I can get > 500 MiB/s, 
this problem only occurs with SW raid (Linux/mdadm).

Example (3ware 9650SE-16PML RAID-6, 15 drives (using EXT4)
$ dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 21.1729 s, 507 MB/s

Justin.
