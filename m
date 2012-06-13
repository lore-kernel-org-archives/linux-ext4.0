From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Discrepancy in 'df' output between kernel 3.0 and 3.2 for ext4?
Date: Wed, 13 Jun 2012 13:27:18 -0500
Message-ID: <4FD8DB86.8030603@redhat.com>
References: <4FD8D731.9070008@cleversafe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Zachary Mark <zmark@cleversafe.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab2FMS1W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2012 14:27:22 -0400
In-Reply-To: <4FD8D731.9070008@cleversafe.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/13/12 1:08 PM, Zachary Mark wrote:
> Ext4 developers,
> 
> I recently upgraded my kernel from 3.0.24 to 3.2.18, and discovered that df is now reporting different statistics for my ext4 file systems (sda1 is ext3 and unaffected).  Notice the difference between the 1K-blocks column and Used column between kernel versions (Available remains constant, as it is merely Used subtracted from the total size):
> 
> 3.0.24:
> [root@box ~]# df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda1              5080796    951932   3866608  20% /
> tmpfs                 12368192        32  12368160   1% /dev/shm
> /dev/sdb1            2907178636    205876 2906972760   1% /media/9c2fb7c6-31db-4e29-b1b4-c199261301f9
> /dev/sdc1            2907178636    205876 2906972760   1% /media/a564e4e1-9b49-40f0-afbd-e0ec4789da70
> /dev/sdd1            2907178636    205876 2906972760   1% /media/f628cda4-ed56-4b8d-be1e-133917569b47
> /dev/sde1            2907178636    359512 2906819124   1% /media/648da0a1-3b1b-42f7-a032-d592bb1435e2
> /dev/sdf1            2907178636    205876 2906972760   1% /media/ce380174-701c-43e8-8986-256d23c3cbd2
> /dev/sdg1            2907178636    205876 2906972760   1% /media/a61227f7-ec93-43ba-b657-6c95b81e51e7
> /dev/sdh1            2907178636    205876 2906972760   1% /media/62b23b60-b70d-4097-ba35-0ffa57de8a44
> /dev/sdi1            2907178636    205876 2906972760   1% /media/479bcb00-f4b0-41e5-9a06-56f02259912c
> /dev/sdj1            2907178636    359512 2906819124   1% /media/0ccf9659-15d1-4e2b-81c7-b3d1fbb61076
> /dev/sdk1            2907178636    205876 2906972760   1% /media/096c90c5-b28f-409a-9f5b-8ae09569ecb0
> /dev/sdl1            2907178636    205876 2906972760   1% /media/671e195b-2e10-4d2d-83cf-96fd07daf3da
> /dev/sdm1            2907178636    205876 2906972760   1% /media/0ec3c3ed-374f-4d52-9ccf-f8a42fb246c5
> 
> 
> 3.2.18:
> [root@box ~]# df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda1              5080796    953576   3864964  20% /
> tmpfs                 12368792        32  12368760   1% /dev/shm
> /dev/sdb1            2928918024  21945264 2906972760   1% /media/9c2fb7c6-31db-4e29-b1b4-c199261301f9
> /dev/sdc1            2928918024  21945264 2906972760   1% /media/a564e4e1-9b49-40f0-afbd-e0ec4789da70
> /dev/sdd1            2928918024  21945264 2906972760   1% /media/f628cda4-ed56-4b8d-be1e-133917569b47
> /dev/sde1            2928918024  22098900 2906819124   1% /media/648da0a1-3b1b-42f7-a032-d592bb1435e2
> /dev/sdf1            2928918024  21945264 2906972760   1% /media/ce380174-701c-43e8-8986-256d23c3cbd2
> /dev/sdg1            2928918024  21945264 2906972760   1% /media/a61227f7-ec93-43ba-b657-6c95b81e51e7
> /dev/sdh1            2928918024  21945264 2906972760   1% /media/62b23b60-b70d-4097-ba35-0ffa57de8a44
> /dev/sdi1            2928918024  21945264 2906972760   1% /media/479bcb00-f4b0-41e5-9a06-56f02259912c
> /dev/sdj1            2928918024  22098900 2906819124   1% /media/0ccf9659-15d1-4e2b-81c7-b3d1fbb61076
> /dev/sdk1            2928918024  21945264 2906972760   1% /media/096c90c5-b28f-409a-9f5b-8ae09569ecb0
> /dev/sdl1            2928918024  21945264 2906972760   1% /media/671e195b-2e10-4d2d-83cf-96fd07daf3da
> /dev/sdm1            2928918024  21945264 2906972760   1% /media/0ec3c3ed-374f-4d52-9ccf-f8a42fb246c5
> 
> I bisected the change to the following commit:
> 
> f975d6bcc7a698a10cc755115e27d3612dcfe322 is the first bad commit
> commit f975d6bcc7a698a10cc755115e27d3612dcfe322
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Fri Sep 9 19:00:51 2011 -0400
> 
>     ext4: teach ext4_statfs() to deal with clusters if bigalloc is enabled
> 
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Reverting this commit on top of 3.2.18 returns the output to pre-3.2 levels.
> 
> Here's my /proc/mounts:
> 
> [root@box ~]# cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/root / ext3 rw,relatime,errors=continue,user_xattr,acl,barrier=1,data=ordered 0 0
> /dev /dev tmpfs rw,relatime,mode=755 0 0
> /proc /proc proc rw,relatime 0 0
> /sys /sys sysfs rw,relatime 0 0
> devpts /dev/pts devpts rw,relatime,gid=5,mode=620 0 0
> tmpfs /dev/shm tmpfs rw,relatime 0 0
> none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
> /dev/sdb1 /media/9c2fb7c6-31db-4e29-b1b4-c199261301f9 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sdc1 /media/a564e4e1-9b49-40f0-afbd-e0ec4789da70 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sdd1 /media/f628cda4-ed56-4b8d-be1e-133917569b47 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sde1 /media/648da0a1-3b1b-42f7-a032-d592bb1435e2 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sdf1 /media/ce380174-701c-43e8-8986-256d23c3cbd2 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sdg1 /media/a61227f7-ec93-43ba-b657-6c95b81e51e7 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sdh1 /media/62b23b60-b70d-4097-ba35-0ffa57de8a44 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sdi1 /media/479bcb00-f4b0-41e5-9a06-56f02259912c ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sdj1 /media/0ccf9659-15d1-4e2b-81c7-b3d1fbb61076 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sdk1 /media/096c90c5-b28f-409a-9f5b-8ae09569ecb0 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sdl1 /media/671e195b-2e10-4d2d-83cf-96fd07daf3da ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> /dev/sdm1 /media/0ec3c3ed-374f-4d52-9ccf-f8a42fb246c5 ext4 rw,noatime,user_xattr,barrier=1,data=ordered 0 0
> 
> Is this discrepancy between the df outputs on the two kernel versions
> expected given my mount options? I decided to come to the list
> because I don't have the technical depth with regard to ext4 to be
> able to analyze the ext4_statfs changes that went into making
> bigalloc work, and I haven't found any reports of similar symptoms
> via web searches or the Documentation/filesystems/ext4.txt. This is

https://bugzilla.redhat.com/show_bug.cgi?id=830412 just came in and is probably the same root cause.

Thanks for the bisect!  I'll let Ted worry about it for now, at least until I have more time.

-Eric

> not a production machine, so I am free to make any alterations or
> patches needed (if such a thing is required). Let me know if there is
> anything additional I need to provide.
> 
> Also, I'm not subscribed to the list, so please cc-me directly on any replies.
> 
> Thank you in advance,
> 
> Zachary Mark
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

