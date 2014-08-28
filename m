From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/27] e2fsck/debugfs: fix descriptor block size handling
 errors with journal_csum
Date: Wed, 27 Aug 2014 21:15:46 -0400
Message-ID: <20140828011546.GA21925@thunk.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234701.11171.99993.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53022 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaH1BPw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2014 21:15:52 -0400
Content-Disposition: inline
In-Reply-To: <20140816234701.11171.99993.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 04:47:01PM -0700, Darrick J. Wong wrote:
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 7cbb99b..9924285 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -415,8 +415,10 @@ static void print_inline_journal_information(ext2_filsys fs)
>  	if (jsb->s_feature_compat &
>  	    ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_CHECKSUM))
>  		printf("%s", _("Journal checksum type:    crc32\n"));
> -	if (jsb->s_feature_incompat &
> -	    ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2))
> +	if ((jsb->s_feature_incompat &
> +	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2)) ||
> +	    (jsb->s_feature_incompat &
> +	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2)))

I assume this should really be: 

+	if ((jsb->s_feature_incompat &
+	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2)) ||
+	    (jsb->s_feature_incompat &
+	     ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V3)))
                                                         ^^^^

amd similarly below in the next if statement?

					- Ted
