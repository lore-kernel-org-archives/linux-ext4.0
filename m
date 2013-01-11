From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: new block group bitmaps not being initialized after resize!?
Date: Thu, 10 Jan 2013 23:44:07 -0700
Message-ID: <25BFE2C2-8FF2-4064-86D3-6CFBF5A2931F@dilger.ca>
References: <20130111000711.GA2490@andromeda.usersys.redhat.com> <50EF65C3.8010406@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:34795 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3AKGoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jan 2013 01:44:14 -0500
Received: by mail-pb0-f48.google.com with SMTP id rq13so776053pbb.35
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2013 22:44:14 -0800 (PST)
In-Reply-To: <50EF65C3.8010406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-01-10, at 6:07 PM, Eric Sandeen wrote:
> On 1/10/13 6:07 PM, Carlos Maiolino wrote:
>> I'm working on a Fedora bugzilla (https://bugzilla.redhat.com/show_bug.cgi?id=852833)
>> together with Eric and we found that the problem described on the
>> bugzilla happens when the commit 93f9052643 is not applied, which
>> is the case of the Fedora 16 kernel being discussed there.
> 
> Also, to be clear, this is with older e2fsprogs which was using the
> old resize interface.  Not sure what the behavior is w/ newer
> e2fsprogs, but we don't see the corruption.
> 
> Note, we see the corruption on these older kernels even when resizing from say 100G to 120G.  It appears fixed upstream, but so much has
> changed, we need to be sure the older interface doesn't have bugs
> lurking, I think.

The original resize code didn't ever know about uninit_bg, so it
would always zero out the inode table, so I suspect that this was
added at some later point. 

>> Although we already found the solution to the problem in the commit
>> above, looking through the commit have raised some questions
>> regarding to the bitmap of the newer block groups added to the FS
>> after it is extended.
>> 
>> The newer block groups do not have flags ITABLE_ZEROED and
>> INODE_UNINIT set, even when 'lazy_itable_init' is enabled.
> 
> In particular, we see things like this in the last pre-resize group:
> 
> Group 799: (Blocks 26181632-26214399) [INODE_UNINIT, ITABLE_ZEROED]
>  Checksum 0xafe7, unused inodes 1936
>  Block bitmap at 25165855 (bg #768 + 31), Inode bitmap at 25166111 (bg #768 + 287)
>  Inode table at 25170087-25170207 (bg #768 + 4263)
>  32768 free blocks, 1936 free inodes, 0 directories, 1936 unused inodes
>  Free blocks: 26181632-26214399
>  Free inodes: 1546865-1548800
> 
> and this in the newly-added groups:
> 
> Group 800: (Blocks 26214400-26247167)
>  Checksum 0xddc4, unused inodes 0
>  Block bitmap at 26236224 (+21824), Inode bitmap at 26236225 (+21825)
>  Inode table at 26214400-26214520
>  32645 free blocks, 1936 free inodes, 0 directories
>  Free blocks: 26214521-26236223, 26236226-26247167
>  Free inodes: 1548801-1550736
> 
> so it says 0 unused inodes, but also 1936 free inodes (?), and
> no UNINIT or ZEROED flags set.  e2fsck finds stale data in the inode table, and goes nuts.

Zeroing the inode table but not setting the INODE_ZEROED flag
would not be harmful, but this seems to not be the case.

When the filesystem is remounted, does the kernel lazyinit
thread zero out the new groups in the inode table?


>> Without this commit, inode stale data might be exposed and also makes fsck complain about all inodes of the newer block groups.
> 
> *nod* :)

That's why 

> so 93f9052643 seems to have accidentally fixed this, by setting
> the unused counter to EXT4_INODES_PER_GROUP(), but it feels like
> we've missed properly setting up this block group.

Actually, just setting the unused counter is not enough to properly
fix this problem.  The lazyinit thread should be started to do
background zeroing of the inode table, otherwise if the group
descriptor is corrupted and the bg_itable_unused value is wrong,
then the uninitialized inodes would be accessed.

> To be honest, though, sometimes I get lost in the sea of flags.
> 
>> The question is, are these flags expected to not be found on
>> these newer block groups or they should be set?
> 
> *nod* :)

Depends on how it is implemented. :-/  The flag should definitely
not be set unless the itable is actually overwritten with zeroes.
It makes sense that the lazyinit thread would do this in the
background while the filesystem is mounted instead of waiting for
the next time that the filesystem is mounted.

Looking at the code, it appears that this is not happening at the
end of the resize, since ext4_register_li_request() is marked
static for the superblock.  It looks like it would be relatively
straight forward to add a call to ext4_register_li_request() to
ext4_resize_end() with the first group added to the resize.

It looks like ext4_run_li_request() will skip groups that are
already marked as INODE_ZERO, so it is fine to always call it even
if the kernel is already setting this itself in some cases (not
that I see this happening).

>> The lack of these flags on newer block groups is an expected
>> behaviour or is something that should be fixed?
>> 
>> FWIW, in the old ext4_group_add(), we added EXT4_BG_INODE_ZEROED
>> flag to the bg_flags, also, I did some tests here and the lack
>> of these flags look to not be affecting filesystem integrity,
>> i.e. new inodes can be properly allocated, which sounds that
>> these uninitialized inodes/bitmaps are set to be initialized
>> as soon as a first inode is allocated on these new BGs.

Well, the old code always zeroed the inode table, and it made sense
to mark it as such.

Cheers, Andreas





