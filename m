From: Johann Lombardi <johann.lombardi@bull.net>
Subject: Re: [RFC] [PATCH 1/1] Nanosecond timestamps
Date: Thu, 8 Feb 2007 11:30:25 +0100
Message-ID: <20070208103025.GB13836@lombardij>
References: <1170427790.6464.6.camel@garfield> <20070206151242.GB3140@lombardij> <20070207203946.GB6565@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>, tytso <tytso@mit.edu>,
	sct <sct@redhat.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56526 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965714AbXBHK3u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Feb 2007 05:29:50 -0500
In-Reply-To: <20070207203946.GB6565@schatzie.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 07, 2007 at 01:39:46PM -0700, Andreas Dilger wrote:
> This has been a bug in several places already, and I wonder if the
> le*_to_cpu() and cpu_to_le*() macros shouldn't do some type checking
> instead of just casting the variable to the specified type?

That would be great.

> The only problem is if casting constants it would be a bit of a pain
> to have to cast them explicitly, though we could have something like:
> 
> #define le16_to_cpu(var) (__builtin_constant(var) || !typecheck(__u16, var) ? \
> 			  __constant_cpu_to_le16(var) : __le16_to_cpu(var))

Very good idea!

> The only question is whether "typecheck" adds extra variables on the stack
> or if the compiler will always optimize them away.

I tend to think it will always be optimized by the compiler.
 
> > If the inode size is EXT3_GOOD_OLD_INODE_SIZE, sbi->s_want_extra_isize won't
> > be initialized. However, it should not be an issue because the ext3_sb_info
> > is set to zero in ext3_fill_super().
> 
> So I'm not sure I understand if you have an objection or if this is just a
> comment.

Just a useless comment :)

> sbi->s_want_extra_isize will be zero and it is not possible for
> sbi->s_inode_size < EXT3_GOOD_OLD_INODE_SIZE so this case won't be hit.

I agree.

Cheers,
Johann
