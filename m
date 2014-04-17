From: Wayne Chou <gmmark12@gmail.com>
Subject: Re: ext4_orphan_cleanup errors during mount a LVM snapshot
Date: Thu, 17 Apr 2014 11:50:37 +0800
Message-ID: <CAGj=0YJivoKZMX7BfSxehfX9_pGySMeG+sVzjXP72so1t-J0jA@mail.gmail.com>
References: <CAGj=0YK3GGuis-jCYT-Rr9LCCg3_xjsYWi-20syTPy7Q8NX3LQ@mail.gmail.com>
	<1804D95E-CD91-41A3-8177-E3E585C9E1E6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:47270 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979AbaDQDui (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 23:50:38 -0400
Received: by mail-qc0-f175.google.com with SMTP id e16so12667362qcx.6
        for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 20:50:38 -0700 (PDT)
In-Reply-To: <1804D95E-CD91-41A3-8177-E3E585C9E1E6@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2014-04-17 0:33 GMT+08:00 Andreas Dilger <adilger@dilger.ca>:
> On Apr 16, 2014, at 2:46 AM, Wayne Chou <gmmark12@gmail.com> wrote:
>> I create a LVM snapshot from a mounted ext4 file system by:
>> "lvcreate -kn --snapshot --name snap1 /dev/mapper/vg1/lv1"
>>
>> And after I mount this snapshot to another folder like:
>> "mount -t ext4 /dev/mapper/vg1-snap1 /mnt/test"
>> the following messages prompted in dmesg:
>>
>> [ 2445.480908] EXT4-fs (dm-6): orphan cleanup on readonly fs
>> [ 2445.502317] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
>> unreferenced inode 131180
>> [ 2445.502355] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
>> unreferenced inode 131176
>> [ 2445.502360] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
>> unreferenced inode 131175
>> [ 2445.502366] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
>> unreferenced inode 131174
>> [ 2445.502372] EXT4-fs (dm-6): ext4_orphan_cleanup: deleting
>> unreferenced inode 131173
>> [ 2445.502376] EXT4-fs (dm-6): 5 orphan inodes deleted
>
> The first question is whether you are experiencing any actual problems
> as a result of the orphan inode cleanup?  This is normal behaviour if
> there are applications with open-unlinked files when the snapshot is taken,
> or if the system crashes at this point.  The orphan cleanup will free up
> these open-unlinked inodes and their blocks at mount time, keeping the
> filesystem consistent.
>
>> To find out what the reason is, I use 'lsof' on lv1's mount point before I take
>> the snapshot.  Then I got some MySQL services that opened these temporary files
>> which causes the orphan inodes in LVM snapshots:
>> mysqld    26257 admin    7u   REG  253,5        0 131173
>> /LV1/.system/tmp/ibTidhzb (deleted)
>> mysqld    26257 admin    8u   REG  253,5        0 131174
>> /LV1/.system/tmp/ibgWhCYc (deleted)
>> mysqld    26257 admin    9u   REG  253,5        0 131175
>> /LV1/.system/tmp/ibJE5pne (deleted)
>> mysqld    26257 admin   10u   REG  253,5        0 131176
>> /LV1/.system/tmp/ibsvL9hg (deleted)
>> mysqld    26257 admin   14u   REG  253,5        0 131180
>> /LV1/.system/tmp/ibcz1qOM (deleted)
>>
>>
>> From the above investigation, the problem gets solved if I
>> disable the MySQL service before taking the LVM snapshot.
>>
>> However, I wonder if there's any other way to solve this issue.
>> For example, can I just blindly remove these orphan inodes when
>> ext4_freeze() is called?  Thank you.
>
> What problem needs to be solved?  Is it just the printing of these
> error messages that is confusing, or something else?
>
> Cheers, Andreas
>
>

Thank you Andreas for the quick reply.

Recently I use lvm2 to take some snapshots with a mounted file system,
and sometimes I'll take some read-only LVM snapshots with:
 "lvcreate -kn -pr --snapshot --name snap2 /dev/mapper/vg1/lv1"

The read-only snapshots still can be mounted and works fine, but
the orphan inodes (caused by those open-unlink file) cannot be
cleaned at mount time.  So what my question is:  If I cannot clean
them now, can I prevent this to happen?

Currently to prevent any open-unlink file during taking LVM snapshots works
for me.  On the other hand, I thought LVM2 would call ext4_freeze()
and ext4_unfreeze()
before and after the snapshot taking, so I also want to ask if it's possible to
put ext4_fs into a consistent state when the ext4_freeze() is called?
Thank you for your help.

Best regards,

- Wayne
