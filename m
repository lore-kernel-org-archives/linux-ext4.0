From: The Ghost <the-ghost@inbox.ru>
Subject: Re: Does ext4 write anything during reading with relatime?
Date: Tue, 08 Dec 2015 00:42:21 +0300
Message-ID: <5665FD3D.1050603@inbox.ru>
References: <5662C472.2050902@inbox.ru> <20151206211454.GB2614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.181.184]:55323 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbbLGVrh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2015 16:47:37 -0500
Received: from smtp32.i.mail.ru (smtp32.i.mail.ru [94.100.177.92])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id BB0CA6415139
	for <linux-ext4@vger.kernel.org>; Tue,  8 Dec 2015 00:42:25 +0300 (MSK)
Received: from [176.193.145.23] (port=38653 helo=[192.168.1.9])
	by smtp32.i.mail.ru with esmtpa (envelope-from <the-ghost@inbox.ru>)
	id 1a63Y7-0003aN-4F
	for linux-ext4@vger.kernel.org; Tue, 08 Dec 2015 00:42:23 +0300
In-Reply-To: <20151206211454.GB2614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/12/15 00:14, Theodore Ts'o wrote:
> On Sat, Dec 05, 2015 at 02:03:14PM +0300, The Ghost wrote:
>> When mounted read-only, naturally, reading from an ext4 filesystem does not
>> cause any write operations. But if I mount it read-write and try to read
>> from it, then apparently some write operations are issued, because my
>> "write-mostly" drive in a RAID1 array spins up. Now, I understand that
>> apparently the mount operation itself does write something, and I do mount
>> it with a "relatime" option, but I'm just reading stuff over and over again
>> - it shouldn't be caused by atime updating. Also, a bug with "write-mostly"
>> finally got fixed, and I'm using a fixed kernel (latest 3.16 from Debian
>> Jessie-backports).
>
> Relatime doesn't guarantee that there will be _no_ atime updates.  You
> would need to mount with noatime if you want to guarantee that there
> will be zero atime updates.
>
> Relatime will update atime if the file is accessed and the atime is
> older than 24 hours.  This guarantees that atime is up to date to
> approximately a day, so you can tell if a file has been accessed
> recently.  This is useful for any system administrators.
>
> But it does mean there will still be quite a bit of atime updates ---
> especially since atime updates apply to directories as much as files.
> Hence, if you haven't mounted the file system in 24 hours, and then
> you run a find operation on the entire file system, the atime for
> every single directory on the file system will need to be updated.
>
> Cheers,
>
> 					- Ted


I know that "relatime" does not guarantee there will be *no* atime 
updates. I know that it updates atime for both files and directories if 
it's older than the last time they have been modified. I did not know 
that it also updates atime if the last atime is older than 24 hours; 
that would indeed render my idea useless. However, what I meant is that 
I create a test array, make an ext4 filesystem on it, put some files 
there (actually, just one file about few hundred megabytes large), read 
them to update the atime, and then spin the disks down and *immediately* 
try to read them again. I did not wait for 24 hours for this test! And 
both drives spin up again, which means there was some write operation. 
Because it does not spin up when mounted read-only, nor when I read from 
the md device itself.

I just tried again. With relatime or noatime, the second drive spins up. 
Always. With read-only, it never spins up. And that doesn't make sense...


-- 
The Ghost
