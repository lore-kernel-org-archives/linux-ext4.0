Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46422 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbeKSOtv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 19 Nov 2018 09:49:51 -0500
Date: Sun, 18 Nov 2018 23:27:27 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 3/9] libe2p: Helpers for configuring the
 encoding superblock fields
Message-ID: <20181119042727.GH32299@thunk.org>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
 <20181015211220.27370-4-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015211220.27370-4-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2018 at 05:12:14PM -0400, Gabriel Krisman Bertazi wrote:
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index f1c405b76339..df8ced088f38 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -1127,4 +1127,17 @@ struct mmp_struct {
>   */
>  #define EXT4_INLINE_DATA_DOTDOT_SIZE	(4)
>  
> +#define EXT4_ENC_STRICT_MODE_FL		(1 << 0) /* Reject invalid sequences? */

Why the question mark?

> +#define UTF8_NORMALIZATION_TYPE_NFKD	(1 << 1)
> +#define UTF8_CASEFOLD_TYPE_NFKDCF	(1 << 4)
> +
> +static const struct ext4_sb_encoding_map {
> +	char *name;
> +	__u16 default_flags;
> +} ext4_encoding_map[] = {
> +	/* 0x0 */ { "ascii", 0x0},
> +	/* 0x1 */ {"utf8-10.0.0", UTF8_NORMALIZATION_TYPE_NFKD|UTF8_CASEFOLD_TYPE_NFKDCF},
> +	{0x0, 0x0},
> +};
> +
>  #endif	/* _LINUX_EXT2_FS_H */

What uses this?  I can't find any other references in either the kernel or
e2fsprogs patches.

						- Ted
