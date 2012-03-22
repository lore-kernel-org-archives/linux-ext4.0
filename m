From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Thu, 22 Mar 2012 17:31:50 +0000
Message-ID: <20120322173150.GY6589@ZenIV.linux.org.uk>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz>
 <20120321231651.GC32041@thunk.org>
 <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
 <1332396053.3058.2.camel@koala>
 <20120322162825.GA4028@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:60697 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2CVRb5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 13:31:57 -0400
Content-Disposition: inline
In-Reply-To: <20120322162825.GA4028@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 22, 2012 at 12:28:25PM -0400, Ted Ts'o wrote:
> On Thu, Mar 22, 2012 at 08:00:41AM +0200, Artem Bityutskiy wrote:
> > On Thu, 2012-03-22 at 06:53 +0100, Thierry Reding wrote:
> > > What's the recommended fix for packages that cannot or will not use
> > > libext2fs, like busybox? Copy the required parts into a private header
> > > and use that instead?
> > 
> > The normal way is to just keep a private copy of the whole header file.
> > Because the on-disk format stays compatible, those programs do not have
> > to update the header very often - only rarely if they want to support
> > some new feature.
> 
> Even if they're not iwlling to use libext2fs (for space reasons, I
> would assume?  It can't be because of license compatibility issues
> since they are both GPLv2), they could just simply grab the ext2_fs.h
> from e2fsprogs.  That has all of the file system definitions for ext2,
> ext3, and ext4.

Ho-hum...  Then we could kill a lot of lines in include/linux/ext2_fs.h.
I wonder how much of what remains has any business being outside of
fs/ext2, actually - AFAICS, there are very few places that might possibly
care:

arch/blackfin/kernel/setup.c:595:       if (*((unsigned short *)(mtd_phys + 0x438)) == EXT2_SUPER_MAGIC)
fs/nfsd/nfs3proc.c:599:         case EXT2_SUPER_MAGIC:  
fs/nfsd/nfs3proc.c:600:                 resp->p_link_max = EXT2_LINK_MAX;
fs/nfsd/nfs3proc.c:601:                 resp->p_name_max = EXT2_NAME_LEN;
init/do_mounts_rd.c:57: struct ext2_super_block *ext2sb;
init/do_mounts_rd.c:70: ext2sb = (struct ext2_super_block *) buf;
init/do_mounts_rd.c:153:        if (ext2sb->s_magic == cpu_to_le16(EXT2_SUPER_MAGIC)) {
init/do_mounts_rd.c:155:                       "RAMDISK: ext2 filesystem found at block %d\n",
init/do_mounts_rd.c:157:                nblocks = le32_to_cpu(ext2sb->s_blocks_count) <<
init/do_mounts_rd.c:158:                        le32_to_cpu(ext2sb->s_log_block_size);
security/selinux/hooks.c:2974:  case EXT2_IOC_GETFLAGS:
security/selinux/hooks.c:2976:  case EXT2_IOC_GETVERSION:
security/selinux/hooks.c:2980:  case EXT2_IOC_SETFLAGS:
security/selinux/hooks.c:2982:  case EXT2_IOC_SETVERSION:

and that's it.  blackfin and do_mounts_rd are doing the same thing (blackfin -
buggy, AFAICS).  Looks like both are  asking for something along the lines of
sector_t detect_ext2(void *image), returning 0 if it's not one and size in
kilobytes if it is...  nfsd one is just plain weird; what the hell is going
on there?  And selinux wants to know 4 ioctl numbers.

Everything else doesn't go beyond fs/ext2; there's a couple of odd macros
in ext[34]_fs.h (EXT._FEATURE_COMPAT_SUPP) using EXT2_FEATURE_COMPAT_EXT_ATTR,
but they are not used anywhere *and* EXT2_FEATURE_COMPAT_EXT_ATTR is not
available in the places that include those headers...
*and* 
