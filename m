From: Andreas Dilger <andreas.dilger@lustre.org>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in	ext4_statfs()
Date: Mon, 16 Nov 2009 15:38:16 -0800
Message-ID: <F64B29C1-A90E-42F5-80CF-5704283D9A1B@sun.com>
References: <4AF4A429.7090507@redhat.com> <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com> <20091108214804.GC7592@mit.edu> <AB457F38-7E3A-43CE-B334-AE363BAE040C@sun.com> <20091115032941.GB4323@mit.edu>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:41875 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbZKPXii (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2009 18:38:38 -0500
Received: by qyk4 with SMTP id 4so2932196qyk.33
        for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 15:38:43 -0800 (PST)
In-Reply-To: <20091115032941.GB4323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-14, at 19:29, Theodore Tso wrote:
> On Sun, Nov 08, 2009 at 09:41:28PM -0700, Andreas Dilger wrote:
>>
>> The reason we added this was for running a read-only e2fsck on a
>> filesystem without getting spurious errors just because the  
>> superblock
>> summaries were incorrect.  The other alternative is to change e2fsck
>> so that it doesn't consider just a block/inode summary an error.
>
> We've been doing this for a while --- e2fsprogs 1.34, since April
> 2003.  In e2fsck/super.c:check_super_block():
>
> 	if ((free_blocks != sb->s_free_blocks_count) ||
> 	    (free_inodes != sb->s_free_inodes_count)) {
> 		if (ctx->options & E2F_OPT_READONLY)
> 			ext2fs_unmark_valid(fs);
> 		else {

The problem is that if you do "e2fsck -fn" it will still report this  
as an error in the filesystem, even though "e2fsck -fp" will silently  
fix it.  I just repeated this test and still see errors, even 30  
minutes after a file was modified, even after multiple syncs.

[adilger@webber ~]$ sync; sleep 10; sync
[adilger@webber ~]$ e2fsck -fn /dev/dm-0
e2fsck 1.41.6.sun1 (30-May-2009)
Warning!  /dev/dm-0 is mounted.
Warning: skipping journal recovery because doing a read-only  
filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Deleted inode 884739 has zero dtime.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -1784645
Fix? no

Inode bitmap differences:  -884739
Fix? no


home: ********** WARNING: Filesystem still has errors **********

home: 72709/2621440 files (17.6% non-contiguous), 4730591/5242880 blocks
[adilger@webber ~]$ echo $?
4

> Hence, I think it's safe to eliminate the updates in ext4_statfs()
> altogether.


Not yet.  I'd be happy if the "-n" e2fsck treated these fields in the  
same
way as it does for the real e2fsck.

The other thing that comes to mind is that we don't recover the journal
for a read-only e2fsck, but we DO recover it on a read-only mount  
seems inconsistent.  It wouldn't be hard to have e2fsck -n read the  
journal and
persistently cache the journal blocks in its internal cache (i.e. flag
them so they can't be discarded from cache) before it runs the rest of  
the
e2fsck.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

