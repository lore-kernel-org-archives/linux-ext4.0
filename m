From: "George Spelvin" <linux@horizon.com>
Subject: Re: Issue with bad file system
Date: 19 Nov 2012 16:15:37 -0500
Message-ID: <20121119211537.5429.qmail@science.horizon.com>
References: <CAPAnFc8z1zn=Fh4LLz-WCq1qHa5oFTQvct04UEh9xDxFTJRvuQ@mail.gmail.com>
Cc: linux-ext4@vger.kernel.org, linux@horizon.com
To: dreusser@gmail.com, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:59768 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751791Ab2KSVPj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 16:15:39 -0500
In-Reply-To: <CAPAnFc8z1zn=Fh4LLz-WCq1qHa5oFTQvct04UEh9xDxFTJRvuQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> There is no encryption to my knowledge (not an expert in mdadm).

linux md doesn't do encryption.  But there are other things, like
dm-crypt, that it can be combined with to do encryption.

That doesn't look like a superblock, that looks like random bits,
as produced by encryption or good compression.  (Could be jpeg,
mp3, or compressed video, it's hard to tell.)

*And* the first few backup superblocks appear to be trashed
as well.

This means either at least a gigabyte of data got overwritten, or some
kind of underlying transformation got changed, so the superblocks
aren't visible in the right places any more.

The obvious possibilities are:
1) Data scrambling, such as from encryption.
2) Address scrambling, such as by moving the components
   in a RAID aroud or assembling with a different stripe
   size.

If you can find anywhere a sector that looks like a superblock as
described at
https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#The_Super_Block

we can try to figure out what's going on.

They're supposed to be located at blocks 32768 * 3**k, 32768 * 5**k,
and 32768 * 7**k, for k = 0, 1, 2, ....  That is, 32768 times 1, 3, 9,
27, 81, 243, ...; 32768 times 1, 5, 25, 125, 625, ...; and 32768 times 1,
7, 49, 343, ...

(Those are 4K blocks; myltiply by 8 for 512-byte sector numbers.)

While the primary superblock contains file system statistics and flags,
the backups are generally never written after file system creation time,
so it's *really* hard to understand how they could have been overwritten
by any sort of normal file system activity.

Let's see... you have 1952211968K in your RAID, meaning 488052992 4K
blocks, and 14895 block groups.

The *last* backup superblocks should be at 3^8 = 6561, 5^5 = 3125,
and 7^4 = 2401.

Try the following:
dumpe2fs -h -o superblock=$((32768*3**8)) /dev/md0
dumpe2fs -h -o superblock=$((32768*5**5)) /dev/md0
dumpe2fs -h -o superblock=$((32768*7**4)) /dev/md0
dumpe2fs -h -o superblock=$((32768*3**7)) /dev/md0

If none of those work, either something overwrote *most* of your drive,
or something has happened to give that illusion.

As Ted says, I'd research option 2 very carefully.
