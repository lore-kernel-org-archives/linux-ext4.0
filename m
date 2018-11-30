Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52218 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbeLACwa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 21:52:30 -0500
Date: Fri, 30 Nov 2018 10:42:43 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH v3 01/12] libe2p: Helpers for configuring the encoding
 superblock fields
Message-ID: <20181130154243.GR31885@thunk.org>
References: <20181126221949.12172-1-krisman@collabora.com>
 <20181126221949.12172-2-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126221949.12172-2-krisman@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2018 at 05:19:38PM -0500, Gabriel Krisman Bertazi wrote:
> +	/* 0x1 */ {"utf8-10.0", (EXT4_UTF8_NORMALIZATION_TYPE_NFKD |
> +				 EXT4_UTF8_CASEFOLD_TYPE_NFKDCF)},

We're using 10.0 here even though the later in the patch we're
installing Unicode 11.0.  What if we just call this utf8-10+?  Unicode
releases new versions every six months these days, and so long as the
case fold rules don't change for any existing characters, but are only
added for new characters added to the new version of Unicode, it would
definitely be OK for strict mode.

Even in relaxed mode, if someone decided to use, say, Klingon
characters not recognized by the Unicode consortium in their system,
and later on the Unicode consortium reassigns those code points to
some obscure ancient script, it would be unfortunate, how much would
it be *our* problem?  The worst that could happen is that if case
folding were enabled, two file names that were previously unique would
be considered identical by the new case folding rules after the
rebooting into the new kernel.  If hashed directories were used, one
or both of the filenames might not be accessible, but it wouldn't lead
to an actual file system level inconsistency.  And data would only be
lost if the wrong file were to get accidentally deleted in the confusion.
 
I'm curious how Windows handles this problem.  Windows and Apple are
happy to include the latest set of emoji's as they become available
--- after all, that's a key competitive advantage for some markets :-)
--- so I'm guessing they must not be terribly strict about Unicode
versioning, either.  So maybe the right thing to do is to just call it
"utf8" and be done with it.  :-)

       	   					- Ted
