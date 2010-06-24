From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: problems with large group descriptors and 64bit
Date: Thu, 24 Jun 2010 13:41:17 -0400
Message-ID: <20100624174117.GD22760@shell>
References: <C14E4BEF-0064-4E36-975F-B74272E246B1@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab0FXRlW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jun 2010 13:41:22 -0400
Content-Disposition: inline
In-Reply-To: <C14E4BEF-0064-4E36-975F-B74272E246B1@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 22, 2010 at 05:24:34PM -0600, Andreas Dilger wrote:
> I was just looking through the 64-bit patches that have landed on master, and I see some obvious bugs with the handling of large group descriptors.  In particular, there are some places that still assume they know the group descriptor size, even in the "opaque" routines added by Eric in commit efe0b401465a3ee836180614b5b435acbb84fc27.
> 
> lib/ext2fs/open.c assumes ext2_group_desc in a couple of places, instead of calling ext2fs_group_desc() to get the right offset:
> #ifdef WORDS_BIGENDIAN  
>                 gdp = (struct ext2_group_desc *) dest;
>                 for (j=0; j < groups_per_block*first_meta_bg; j++)
>                         ext2fs_swap_group_desc2(fs, gdp++);
> #endif

Yeah, Eric and I pointed this one out when they went in but didn't
hear back.  I never compiled with big-endian, much less tested it.  I
suspect getting 64-bit working on big-endian will require fixing a
number of other bugs.

> lib/ext2fs/blknum.c assumes 64BIT means ext4_group_desc, not s_desc_size:
> struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
>                                           struct opaque_ext2_group_desc *gdp,
>                                           dgrp_t group)
> {               
>         if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT)
>                 return (struct ext2_group_desc *)
>                         ((struct ext4_group_desc *) gdp + group);
>         else
>                 return (struct ext2_group_desc *) gdp + group;
> }

I'm not sure I understand.  Are there more than two possible sizes for
group descriptors?  Or is the existing code correct but you'd like to
use s_desc_size directly for simplicity?  Or something else?

Thanks,

-VAL
