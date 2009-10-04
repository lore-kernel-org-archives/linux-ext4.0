From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid/Makefile.in: ignore rmdir non-empty dir error
Date: Sat, 3 Oct 2009 22:29:52 -0400
Message-ID: <20091004022952.GE15688@mit.edu>
References: <1254135442-28755-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52843 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbZJDCab (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Oct 2009 22:30:31 -0400
Content-Disposition: inline
In-Reply-To: <1254135442-28755-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 28, 2009 at 06:57:22PM +0800, Peng Tao wrote:
>  		checker/* blkid_types.h ../libblkid.a ../libblkid_p.a \
>  		$(SMANPAGES) blkid
> -	-rmdir tests
> +	-rmdir --ignore-fail-on-non-empty tests
>  

Sorry, NACK.  This will blow up on systems that aren't using the GNU
shellutils.  The error is ignored, which is good enough.  We can do
something like this instead:

	@echo rmdir tests/tmp tests
	-@rmdir tests/tmp tests >& /dev/null

If we really care, I suppose.

					- Ted
