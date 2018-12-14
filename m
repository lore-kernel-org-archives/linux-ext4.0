Return-Path: <SRS0=b4XO=OX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35212 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbeLNDKM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Dec 2018 22:10:12 -0500
Date: Thu, 13 Dec 2018 22:10:09 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH 1/2] e2fsck: allow to check >2GB sized directory
Message-ID: <20181214031009.GA20880@thunk.org>
References: <20181213213156.44773-1-artem.blagodarenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213213156.44773-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 14, 2018 at 12:31:55AM +0300, Artem Blagodarenko wrote:
> After large_dir feature has been added, e2fsprogs is
> ready for directories > 2GB, so we can remove e2fsck
> directory size check.
> 
>  
> -	if (p->is_dir && blockcnt > (1 << (21 - fs->super->s_log_block_size)))
> +	if (p->is_dir && !ext2fs_has_feature_largedir(fs->super) &&
> +	    blockcnt > (1 << (21 - fs->super->s_log_block_size)))
>  		problem = PR_1_TOOBIG_DIR;
> -	if (p->is_reg && p->num_blocks+1 >= p->max_blocks)
> +	if ((p->is_reg || p->is_dir) && p->num_blocks + 1 >= p->max_blocks)
>  		problem = PR_1_TOOBIG_REG;
>  	if (!p->is_dir && !p->is_reg && blockcnt > 0)
>  		problem = PR_1_TOOBIG_SYMLINK;

In the largedir case, if the directory is too big, it will return
PR_1_TOOBIG_REG; it should still return PR_1_TOOBIG_DIR, so the
message is not confusing.

Could you fix this, please?   Thanks!!

					- Ted
