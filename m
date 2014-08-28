From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/27] e2fsck/debugfs: fix descriptor block size handling
 errors with journal_csum
Date: Wed, 27 Aug 2014 18:33:13 -0700
Message-ID: <20140828013313.GA16543@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234701.11171.99993.stgit@birch.djwong.org>
 <20140828011546.GA21925@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18337 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaH1BdU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2014 21:33:20 -0400
Content-Disposition: inline
In-Reply-To: <20140828011546.GA21925@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2014 at 09:15:46PM -0400, Theodore Ts'o wrote:
> On Sat, Aug 16, 2014 at 04:47:01PM -0700, Darrick J. Wong wrote:
> > diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> > index 7cbb99b..9924285 100644
> > --- a/misc/dumpe2fs.c
> > +++ b/misc/dumpe2fs.c
> > @@ -415,8 +415,10 @@ static void print_inline_journal_information(ext2_filsys fs)
> >  	if (jsb->s_feature_compat &
> >  	    ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_CHECKSUM))
> >  		printf("%s", _("Journal checksum type:    crc32\n"));
> > -	if (jsb->s_feature_incompat &
> > -	    ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2))
> > +	if ((jsb->s_feature_incompat &
> > +	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2)) ||
> > +	    (jsb->s_feature_incompat &
> > +	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2)))
> 
> I assume this should really be: 
> 
> +	if ((jsb->s_feature_incompat &
> +	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2)) ||
> +	    (jsb->s_feature_incompat &
> +	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V3)))
>                                                          ^^^^
> 
> amd similarly below in the next if statement?

Err... oops.  Yes, you are correct.  Thank you for catching this.

--D

> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
