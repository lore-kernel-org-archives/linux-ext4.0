From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Build using CFLAGS passed in at configure
Date: Tue, 2 Aug 2011 06:03:59 -0400
Message-ID: <20110802100359.GA8028@infradead.org>
References: <20110730165517.GA13918@infradead.org>
 <1312235904-21187-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: hch@infradead.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44494
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584Ab1HBKEB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 06:04:01 -0400
Content-Disposition: inline
In-Reply-To: <1312235904-21187-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 01, 2011 at 05:58:24PM -0400, Theodore Ts'o wrote:
> In order to build xfsprogs in a hermetic build, we need be able to
> pass in -I and -L flags to the compiler and linker, respectively.
> This needs to be used by the configure script, but we also need to
> make sure these flags are used by the Makefiles as well.

Thanks a lot a Ted!

I've added this to xfsprogs, xfsdump and dmapi.  xfstests actually
already has it, sent in in 2009 by Arek for the same reason you want
it in xfsprogs.  Wish we would have been a bit better to propagate build
system fixes.

