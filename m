Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52436 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbeLADWm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 22:22:42 -0500
Date: Fri, 30 Nov 2018 11:12:51 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH v3 08/12] ext2fs: nls: Support UTF-8 11.0 with NFKD
 normalization
Message-ID: <20181130161251.GA3512@thunk.org>
References: <20181126221949.12172-1-krisman@collabora.com>
 <20181126221949.12172-9-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126221949.12172-9-krisman@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2018 at 05:19:45PM -0500, Gabriel Krisman Bertazi wrote:
> +static int utf8_casefold(const struct nls_table *table,
> +			  const unsigned char *str, size_t len,
> +			  unsigned char *dest, size_t dlen)
> +{
> +	const struct utf8data *data = utf8nfkdicf(UNICODE_AGE(10,0,0));
> +	struct utf8cursor cur;
> +	size_t nlen = 0;
> +
> +	if (utf8ncursor(&cur, data, str, len) < 0)
> +		goto invalid_seq;
> +
> +	for (nlen = 0; nlen < dlen; nlen++) {
> +		dest[nlen] = utf8byte(&cur);
> +		if (!dest[nlen])
> +			return nlen;
> +		if (dest[nlen] == -1)
> +			break;
> +	}
> +invalid_seq:
> +	/* Treat the sequence as a binary blob. */
> +	memcpy(dest, str, len);
> +	return len;
> +
> +}

So it looks like the interface is if the destination buffer is too
small OR if the string is not a valid UTF-8 string, we treat it as a
binary blob.  I wonder if we would be better off if this function
actually signalling that there is a problem?  (Buffer too small,
invalid UTF-8 string).

It's fine to treat it as a binary blob, and copy it out to the
destination buffer, but I can imagine be use cases where knowing this
will be useful.  *Especially* the destination buffer too small case;
I'm actually a little nervous about having it silently ignoring that
error condition and just copying the binary blob.

Also, there *really* needs to be a check before dlen is assumed to be
>= len in the memcpy after the invalid_seq label.

							- Ted
