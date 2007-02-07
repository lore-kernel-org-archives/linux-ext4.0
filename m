From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [PATCH 1/1] Nanosecond timestamps
Date: Wed, 7 Feb 2007 13:39:46 -0700
Message-ID: <20070207203946.GB6565@schatzie.adilger.int>
References: <1170427790.6464.6.camel@garfield> <20070206151242.GB3140@lombardij>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>, tytso <tytso@mit.edu>,
	sct <sct@redhat.com>
To: Johann Lombardi <johann.lombardi@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:47979 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161373AbXBGUjt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Feb 2007 15:39:49 -0500
Content-Disposition: inline
In-Reply-To: <20070206151242.GB3140@lombardij>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 06, 2007  16:12 +0100, Johann Lombardi wrote:
> > +       if (sbi->s_inode_size > EXT3_GOOD_OLD_INODE_SIZE) {
> > +           EXT3_SB(sb)->s_want_extra_isize = sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE;
>
> Maybe EXT3_SB(sb)-> could be replaced by sbi-> here and in the lines below.

Yes, this should definitely be done.  It also increases clarity between
sbi->s_want_extra_isize and es->s_want_extra_isize.

> > +                       if (EXT3_SB(sb)->s_want_extra_isize <
> > +                           le32_to_cpu(es->s_min_extra_isize))
>                                 ^^
> > +                               EXT3_SB(sb)->s_want_extra_isize =
> > +                                       le32_to_cpu(es->s_min_extra_isize);
>                                             ^^
> Since es->s_{min,want}_extra_isize are both __u16 (BTW, shouldn't it be
> __le16?), I think you should use le16_to_cpu() instead of le32_to_cpu().

You are right - this works fine on little endian systems, but fails on
big endian systems where you will get the other half of the word.

This has been a bug in several places already, and I wonder if the
le*_to_cpu() and cpu_to_le*() macros shouldn't do some type checking
instead of just casting the variable to the specified type?

The only problem is if casting constants it would be a bit of a pain
to have to cast them explicitly, though we could have something like:

#define le16_to_cpu(var) (__builtin_constant(var) || !typecheck(__u16, var) ? \
			  __constant_cpu_to_le16(var) : __le16_to_cpu(var))
			   
The only question is whether "typecheck" adds extra variables on the stack
or if the compiler will always optimize them away.

> > +       /* Check if enough inode space is available */
> > +       if (EXT3_GOOD_OLD_INODE_SIZE + EXT3_SB(sb)->s_want_extra_isize >
> > +                                                       sbi->s_inode_size) {
> > +               EXT3_SB(sb)->s_want_extra_isize = sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE;
> > +               printk(KERN_INFO "EXT3-fs: required extra inode space not"
> > +                       "available.\n");
> > +       }
> 
> If the inode size is EXT3_GOOD_OLD_INODE_SIZE, sbi->s_want_extra_isize won't
> be initialized. However, it should not be an issue because the ext3_sb_info
> is set to zero in ext3_fill_super().

So I'm not sure I understand if you have an objection or if this is just a
comment.  sbi->s_want_extra_isize will be zero and it is not possible for
sbi->s_inode_size < EXT3_GOOD_OLD_INODE_SIZE so this case won't be hit.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
