Return-Path: <SRS0=oRRr=OR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36986 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbeLHSgv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 8 Dec 2018 13:36:51 -0500
Date: Sat, 8 Dec 2018 13:36:37 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: linux-ext4@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH] e2p: Print encoding information in superblock dump
Message-ID: <20181208183637.GD20708@thunk.org>
References: <20181204211609.27477-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204211609.27477-1-krisman@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 04, 2018 at 04:16:09PM -0500, Gabriel Krisman Bertazi wrote:
> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
> index a7586e094da1..bb1fc8aa94da 100644
> --- a/lib/e2p/ls.c
> +++ b/lib/e2p/ls.c
    ....
> +	if (encoding == EXT4_ENC_UTF8_11_0) {
> +		if (flags & EXT4_UTF8_NORMALIZATION_TYPE_NFKD)
> +			fputs(" NFKD", f);
> +		else
> +			fputs(" Unnormalized", f);
> +		flags_found++;
> +
> +		if (flags & EXT4_UTF8_CASEFOLD_TYPE_NFKDCF)
> +			fputs(" NFKDCF", f);
> +		else
> +			fputs(" toUpper", f);
> +		flags_found++;
> +	}

I don't understand this.  Why is "toUpper" the opposite of
"CASEFOLD_TYPE_NFKDCF"?  From what I can tell looking at the kernel
patches, it appears that if CASEFOLD_TYPE_NFKDCF is not specified, no
case folding is done at all.  And it appears the opposite of "toupper"
is "tolower" --- for ASCII case folding.

More generally, we don't have a way of setting these flags, and I'm
wondering if we should just make a decision and be done with it.
After all, without any way of changing the flags, there's only one
code path that is going to be well tested, and realistically user
programs will come to *expect* only one way file systems will do
things.  The MacOS world has discovered the hard way what happens if
they try to change normalization conventions from one to another,
leading to all sorts of confusion for application programmers.

So perhaps we should just remove these flags from the superblock, and
only support one way of doing things.  We ask the opinion of various
stake-holders --- the Samba folks, fsdevel, Steam, etc.  But whether
we decide NFC, NFD, NFKC or NFKD, I suspect we'll be better off just
picking one and only one way of doing things.   WDYT?

	    	     	     	      		- Ted
