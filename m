From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Do we need dump for ext4?
Date: Fri, 29 Aug 2008 13:14:30 -0500
Message-ID: <48B83C86.2010507@redhat.com>
References: <48B6BD02.3080307@redhat.com> <48B7ED40.6020508@redhat.com> <20080829141703.GC30887@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Ric Wheeler <rwheeler@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53302 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbYH2SQb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Aug 2008 14:16:31 -0400
In-Reply-To: <20080829141703.GC30887@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> Just for completeness's sake, can you apply the following patch to
> dump, and then try doing a benchmark run using dump on ext4?
> 
> I'm curious how it would compare.
> 
>       	       	   	   	     	       - Ted
> 
> Index: dump-0.4b41/dump/traverse.c
> ===================================================================
> --- dump-0.4b41.orig/dump/traverse.c
> +++ dump-0.4b41/dump/traverse.c
> @@ -157,14 +157,6 @@ int dump_fs_open(const char *disk, ext2_
>  			retval = EXT2_ET_UNSUPP_FEATURE;
>  			ext2fs_close(*fs);
>  		}
> -		else if ((retval = es->s_feature_incompat &
> -					~(EXT2_LIB_FEATURE_INCOMPAT_SUPP |
> -					  EXT3_FEATURE_INCOMPAT_RECOVER))) {
> -			msg("Unsupported feature(s) 0x%x in filesystem\n",
> -				retval);
> -			retval = EXT2_ET_UNSUPP_FEATURE;
> -			ext2fs_close(*fs);
> -		}
>  		else {
>  			if (es->s_feature_compat &
>  				EXT3_FEATURE_COMPAT_HAS_JOURNAL && 

Yep, will do.  Should have included it in the run (in last, in case
anything exploded...) :)

I'm traveling but will give it a shot soon.

-Eric
