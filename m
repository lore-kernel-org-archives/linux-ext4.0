From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/4][e2fsprogs] Allow FLEX_BG to be use as a feature
	option at mke2fs time.
Date: Sat, 3 Nov 2007 14:18:58 -0400
Message-ID: <20071103181858.GA18836@thunk.org>
References: <20070814043245.32206.34785.stgit@gara> <20070814043257.32206.56210.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49288 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbXKDNhb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Nov 2007 08:37:31 -0500
Content-Disposition: inline
In-Reply-To: <20070814043257.32206.56210.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 13, 2007 at 11:32:57PM -0500, Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Allow FLEX_BG to be use as a feature option at mke2fs time.
> 
> @@ -1363,6 +1364,10 @@ static void PRS(int argc, char *argv[])
>  		fs_param.s_feature_ro_compat = 0;
>   	}
>  	
> +	if (fs_param.s_feature_incompat &
> +	    EXT4_FEATURE_INCOMPAT_FLEX_BG)
> +		fs_param.s_feature_incompat |= EXT2_FEATURE_INCOMPAT_META_BG;
> +
>  	/* Set first meta blockgroup via an environment variable */
>  	/* (this is mostly for debugging purposes) */
>  	if ((fs_param.s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&

Why is this hunk here?  Just for convenience, right?  Technically
there's no reason why we can't relax the location of the inode tables
and bitmap blocks without going to meta_bg.  My inclination is to keep
the options as orthogonal as possible, and use mke2fs.conf to allow
the user to conveniently set up filesystems with the appropriate
configuration parameters.

						- Ted
