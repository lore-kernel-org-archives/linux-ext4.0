From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: libext2fs: don't flush to device opened in read-only mode
Date: Mon, 29 May 2017 19:43:27 -0400
Message-ID: <20170529234327.pnr5okbjwyuvi4cs@thunk.org>
References: <118AAB5F26BFB34DB5CDA7DA33334DB9B5FF41@vmsk-exch-01.paragon-software.com>
 <20170524215622.fh7yin4fttggw36f@thunk.org>
 <118AAB5F26BFB34DB5CDA7DA33334DB9B6072B@vmsk-exch-01.paragon-software.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Konstantin Chistyakov <Konstantin.Chistyakov@paragon-software.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49488 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750864AbdE2Xna (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 May 2017 19:43:30 -0400
Content-Disposition: inline
In-Reply-To: <118AAB5F26BFB34DB5CDA7DA33334DB9B6072B@vmsk-exch-01.paragon-software.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 25, 2017 at 12:12:21PM +0000, Konstantin Chistyakov wrote:
> Updating path:
> Subject: [PATCH] e2fsck: don't flush to device opened in read-only mode

Thanks, applied, with some typographical fix ups.

Also, in the future please include your Developer's Certification of
Origin (aka, the Signed-Off-by)[1].  In this case the patch is obvious
enough (and I suggested it), that I'll apply it without it, but in the
future, I'd appreicate if you could include it in your patches.

[1] https://developercertificate.org/

Cheers,

					- Ted
