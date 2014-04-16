From: Wayne Chou <gmmark12@gmail.com>
Subject: ext4_orphan_cleanup errors during mount a LVM snapshot
Date: Wed, 16 Apr 2014 16:46:42 +0800
Message-ID: <CAGj=0YK3GGuis-jCYT-Rr9LCCg3_xjsYWi-20syTPy7Q8NX3LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57928 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaDPIqn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 04:46:43 -0400
Received: by mail-qa0-f46.google.com with SMTP id i13so10430332qae.33
        for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 01:46:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear all,

I create a LVM snapshot from a mounted ext4 file system by:
"lvcreate -kn --snapshot --name snap1 /dev/mapper/vg1/lv1"

And after I mount this snapshot to another folder like:
"mount -t ext4 /dev/mapper/vg1-snap1 /mnt/test"
the following messages prompted in dmesg:

[ 2445.480908] EXT4-fs (dm-6): orphan cleanup on readonly fs
[ 2445.502317] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
unreferenced inode 131180
[ 2445.502355] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
unreferenced inode 131176
[ 2445.502360] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
unreferenced inode 131175
[ 2445.502366] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
unreferenced inode 131174
[ 2445.502372] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
unreferenced inode 131173
[ 2445.502376] EXT4-fs (dm-6): 5 orphan inodes deleted

To find out what the reason is, I use 'lsof' on lv1's mount point before I take
the snapshot.  Then I got some MySQL services that opened these temporary files
which causes the orphan inodes in LVM snapshots:
mysqld    26257 admin    7u   REG  253,5        0 131173
/LV1/.system/tmp/ibTidhzb (deleted)
mysqld    26257 admin    8u   REG  253,5        0 131174
/LV1/.system/tmp/ibgWhCYc (deleted)
mysqld    26257 admin    9u   REG  253,5        0 131175
/LV1/.system/tmp/ibJE5pne (deleted)
mysqld    26257 admin   10u   REG  253,5        0 131176
/LV1/.system/tmp/ibsvL9hg (deleted)
mysqld    26257 admin   14u   REG  253,5        0 131180
/LV1/.system/tmp/ibcz1qOM (deleted)


>From the above investigation, the problem gets solved if I
disable the MySQL service before taking the LVM snapshot.

However, I wonder if there's any other way to solve this issue.
For example, can I just blindly remove these orphan inodes when
ext4_freeze() is called?  Thank you.

- Wayne
