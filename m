From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/7] ext4: fold ext4_generic_write_end() into
 ext4_write_end()
Date: Wed, 27 Mar 2013 16:35:09 +0100
Message-ID: <20130327153509.GC1771@quack.suse.cz>
References: <1364170014-10295-1-git-send-email-tytso@mit.edu>
 <1364170014-10295-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab3C0Pf2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 11:35:28 -0400
Content-Disposition: inline
In-Reply-To: <1364170014-10295-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 24-03-13 20:06:49, Ted Tso wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After collpasing the handling of data ordered and data writeback
> codepath, ext4_generic_write_end() has only one caller,
> ext4_write_end().  So we fold it into ext4_write_end().
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inode.c | 67 +++++++++++++++++++++++----------------------------------
>  1 file changed, 27 insertions(+), 40 deletions(-)
> 
...
> @@ -1105,7 +1123,7 @@ static int ext4_generic_write_end(struct file *file,
>  
>  	/*
>  	 * No need to use i_size_read() here, the i_size
> -	 * cannot change under us because we hold i_mutex.
> +	 * cannot change under us because we hole i_mutex.
  Typo added here. Otherwise the patch is fine. You can add
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
