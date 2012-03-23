From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Thu, 22 Mar 2012 18:25:09 -0600
Message-ID: <43D088FE-7FB5-4C9F-A4FF-2B01DB392F43@gmail.com>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de> <20120321222357.GB24330@quack.suse.cz> <20120321231651.GC32041@thunk.org> <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de> <1332396053.3058.2.camel@koala> <20120322162825.GA4028@thunk.org> <20120322173150.GY6589@ZenIV.linux.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	ThierryReding <thierry.reding@avionic-design.de>,
	Jan Kara <jack@suse.cz>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53147 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab2CWAYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 20:24:34 -0400
In-Reply-To: <20120322173150.GY6589@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-22, at 11:31, Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Thu, Mar 22, 2012 at 12:28:25PM -0400, Ted Ts'o wrote:
>> 
>> Even if they're not iwlling to use libext2fs (for space reasons, I
>> would assume?  It can't be because of license compatibility issues
>> since they are both GPLv2), they could just simply grab the ext2_fs.h
>> from e2fsprogs.  That has all of the file system definitions for ext2,
>> ext3, and ext4.
> 
> Ho-hum...  Then we could kill a lot of lines in include/linux/ext2_fs.h.
> I wonder how much of what remains has any business being outside of
> fs/ext2, actually - AFAICS, there are very few places that might possibly
> care:
> 
> arch/blackfin/kernel/setup.c:595:       if (*((unsigned short *)(mtd_phys + 0x438)) == EXT2_SUPER_MAGIC)
> fs/nfsd/nfs3proc.c:599:         case EXT2_SUPER_MAGIC:  
> fs/nfsd/nfs3proc.c:600:                 resp->p_link_max = EXT2_LINK_MAX;
> fs/nfsd/nfs3proc.c:601:                 resp->p_name_max = EXT2_NAME_LEN;

These don't really make sense to be using ext2 constants. 

> init/do_mounts_rd.c:57: struct ext2_super_block *ext2sb;
> init/do_mounts_rd.c:70: ext2sb = (struct ext2_super_block *) buf;
> init/do_mounts_rd.c:153:        if (ext2sb->s_magic == cpu_to_le16(EXT2_SUPER_MAGIC)) {
> init/do_mounts_rd.c:155:                       "RAMDISK: ext2 filesystem found at block %d\n",
> init/do_mounts_rd.c:157:                nblocks = le32_to_cpu(ext2sb->s_blocks_count) <<
> init/do_mounts_rd.c:158:                        le32_to_cpu(ext2sb->s_log_block_size);
> security/selinux/hooks.c:2974:  case EXT2_IOC_GETFLAGS:
> security/selinux/hooks.c:2976:  case EXT2_IOC_GETVERSION:
> security/selinux/hooks.c:2980:  case EXT2_IOC_SETFLAGS:
> security/selinux/hooks.c:2982:  case EXT2_IOC_SETVERSION:

These ones should be using the generic FS_IOC_{GET,SET}_FLAGS.

It isn't clear that there is any legitimate use for EXT2_IOC_SETVERSION, since it isn't possible to allocate specific inode numbers, so there isn't really any use to set the inode version.  Ostensibly it was for user-space NFS, but it can't be used for this, and we are planning to deprecate it from ext2/3/4 already due to incompatibility with the metadata checksum feature. 

> and that's it.  blackfin and do_mounts_rd are doing the same thing (blackfin -
> buggy, AFAICS).  Looks like both are  asking for something along the lines of
> sector_t detect_ext2(void *image), returning 0 if it's not one and size in
> kilobytes if it is...  nfsd one is just plain weird; what the hell is going
> on there?  And selinux wants to know 4 ioctl numbers.
> 
> Everything else doesn't go beyond fs/ext2; there's a couple of odd macros
> in ext[34]_fs.h (EXT._FEATURE_COMPAT_SUPP) using EXT2_FEATURE_COMPAT_EXT_ATTR,
> but they are not used anywhere *and* EXT2_FEATURE_COMPAT_EXT_ATTR is not
> available in the places that include those headers...
> *and* 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
