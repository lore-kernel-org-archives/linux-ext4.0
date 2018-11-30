Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52328 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727207AbeLADEs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 22:04:48 -0500
Date: Fri, 30 Nov 2018 10:54:59 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH v3 04/12] lib/ext2fs: Implement NLS support
Message-ID: <20181130155459.GS31885@thunk.org>
References: <20181126221949.12172-1-krisman@collabora.com>
 <20181126221949.12172-5-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126221949.12172-5-krisman@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2018 at 05:19:41PM -0500, Gabriel Krisman Bertazi wrote:
> +static int ascii_casefold(const struct nls_table *table,
> +			  const unsigned char *str, size_t len,
> +			  unsigned char *dest, size_t dlen)
> +{
> +	unsigned i;
> +
> +	for (i = 0; i < len; i++)
> +		dest[i] = charset_toupper(table, str[i]);
> +
> +	return len;
> +}
> +
> +static int ascii_normalize(const struct nls_table *table,
> +			   const unsigned char *str, size_t len,
> +			   unsigned char *dest, size_t dlen)
> +{
> +	memcpy(dest, str, len);
> +	return len;
> +}

Shouldn't these two functions at least check to make sure dlen >= len
and return an error if not?

It's not paranoia when there are people out there actually trying to
get you.  :-)

						- Ted
