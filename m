From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 01/22] ext4: add ext4_mpage_readpages()
Date: Mon, 6 Apr 2015 15:08:51 -0600
Message-ID: <85D94901-4D36-45F3-A57C-0D6010DE18FA@dilger.ca>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu> <1428012659-12709-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35418 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbbDFVI4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2015 17:08:56 -0400
Received: by pddn5 with SMTP id n5so56051623pdd.2
        for <linux-ext4@vger.kernel.org>; Mon, 06 Apr 2015 14:08:55 -0700 (PDT)
In-Reply-To: <1428012659-12709-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 2, 2015, at 4:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> This takes code from fs/mpage.c and optimizes it for ext4.  Its
> primary reason is to allow us to more easily add encryption to ext4's
> read path in an efficient manner.
> 
[snip]
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> new file mode 100644
> index 0000000..9ca4dfc
> --- /dev/null
> +++ b/fs/ext4/readpage.c
> @@ -0,0 +1,261 @@
> +/*
> + * linux/fs/ext4/readpage.c
> + *
> + * This was originally taken from fs/mpage.c
> + *
> + * The intent is the ext4_mpage_readpages() function here is intended
> + * to replace mpage_readpages() in the general case, not just for
> + * encrypted files.  It has some limitations (see below), where it
> + * will fall back to read_block_full_page(), but these limitations
> + * should never be hit when page_size != block_size.

Shouldn't this be "... should never be hit when page_size == block_size"?
Otherwise, we'd hit them almost all the time...

Cheers, Andreas




