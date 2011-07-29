From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] dumpe2fs: Warn when filesystem is mounted read-write
Date: Fri, 29 Jul 2011 03:28:44 -0600
Message-ID: <075FF445-CA0B-4BE8-B322-3CC7C3A2B2B9@dilger.ca>
References: <1311866224-27351-1-git-send-email-jack@suse.cz> <1968AC77-D564-47DB-8D15-5F5FBB75B08B@dilger.ca> <20110728195131.GH5044@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:39413 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab1G2J2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jul 2011 05:28:46 -0400
In-Reply-To: <20110728195131.GH5044@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-28, at 1:51 PM, Jan Kara wrote:
> On Thu 28-07-11 10:44:30, Andreas Dilger wrote:
>> Jan, does this specifically relate to the free blocks or free inodes
>> count?  My preference would actually be to have dumpe2fs print the
>> correct values. I guess that means reading all of the group descriptors
>> and adding up the free block/inode counts like the kernel does. 
> 
>  Yes, the number of free blocks and inodes are the main offenders,
> although there are other fields like s_wtime, or s_kbytes_written that are
> updated only during umount.
> 
>> I'm not against this patch in principle, since any operation on a mounted
>> filesystem is inherently racy, but as it stands now the information
>> printed by dumpe2fs can be completely useless. 
> 
>  Well, but OTOH in some cases it might be desirable to actually see the
> real numbers stored and since dumpe2fs is mainly for debugging purposes I'd
> rather have it's output as close to what's on disk as possible. If people
> are interested in amount of free blocks / inodes, they should use statfs(2)
> after all.  So I'd be reluctant to add some computations like you
> suggest... What dumpe2fs might do is sync the filesystem (and do statfs())
> to force most of the information to disk when it sees the filesystem is
> mounted. I can update my patch to do this when people think it's desirable.

It would be nice if there was a simple way to update the superblock with this data.  Calling sync() wouldn't be an unreasonable time to update the superblock, or even just doing it once an hour automatically from the kernel, or at the next time the filesystem is modified.  In particular, it makes sense to update s_kbytes_written periodically instead of just at unmount time, or in some cases it may never updated if the filesystem is never unmounted cleanly.

Cheers, Andreas





