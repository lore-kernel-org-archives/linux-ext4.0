Return-Path: <SRS0=WpiV=MV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53866 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbeJIJF2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Oct 2018 05:05:28 -0400
Date: Mon, 8 Oct 2018 21:50:53 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: remove QUOTA flag setting in set_qf_name()
Message-ID: <20181009015053.GC3369@thunk.org>
References: <20181008235013.13687-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181008235013.13687-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 09, 2018 at 07:50:13AM +0800, Chengguang Xu wrote:
> Mount flag QUOTA is the same as flag USRQUOTA in ext4, so should
> not set flag QUOTA in set_qf_name().
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>  fs/ext4/super.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 1145109968ef..9ed33e4860db 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1566,7 +1566,6 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
>  		goto errout;
>  	}
>  	sbi->s_qf_names[qtype] = qname;
> -	set_opt(sb, QUOTA);

No, sorry.  This is still needed so that the usrjquota and the
grpjquota mount options will work correctly.  And it's not like
set_qf_name() is a performance hot path.

					- Ted
