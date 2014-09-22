From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: Sun, 21 Sep 2014 21:17:06 -0400
Message-ID: <20140922011706.GC30646@thunk.org>
References: <20140921175515.GA30646@thunk.org>
 <20140921210416.27127.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40042 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaIVBRP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 21:17:15 -0400
Content-Disposition: inline
In-Reply-To: <20140921210416.27127.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 21, 2014 at 05:04:16PM -0400, linux@horizon.com wrote:
> One things I'm coming across immediately that I have to ask for
> design guidance on is the hash algorithm number assignment:
> 
> - Should I leave room for more hashes with a signed/unsigned distinction,
>   or should I assume that's a historical kludge that won't be perpetuated?
>   SipHash is defined on a byte string, so there isn't really a signed
>   version.

It's a historical kludge that shouldn't be needed for new checksums;
just make sure it is defined correctly and that you test interop
between Big-Endian and Little-Endian machines.  The awfulness we had
was because there were already a large number of file systems out in
the field on PowerPC and Intel machines, so we needed to preserve
compatibility as much as possible, such that newer kernels could
correctly understand filesystems that had originally been created on
the opposite-endian system.

Cheers,

						- Ted
