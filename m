From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: fix build when posix_fadvise is missing
Date: Wed, 1 Jan 2014 12:22:05 -0500
Message-ID: <20140101172205.GC17519@thunk.org>
References: <33245e3808058c72b66931ac14aea8d5dc6d1ba5.1388572103.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44950 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbaAARWK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jan 2014 12:22:10 -0500
Content-Disposition: inline
In-Reply-To: <33245e3808058c72b66931ac14aea8d5dc6d1ba5.1388572103.git.baruch@tkos.co.il>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 01, 2014 at 12:28:23PM +0200, Baruch Siach wrote:
> uClibc declares posix_fadvise() even when the architecture does not provide
> one. The static posix_fadvise() signature is not compatible with POSIX. Rename
> the internal implementation to fix this.

If the architecture doesn't provide posix_fadvise(), does that imply
that __NR_fadvise64_64 also doesn't exist?

Or do you mean that for some reason, uClibc is not providing
posix_fadvise on all architectures, even though the kernel supports it?

That seems wierd.

	      	     		    	 	- Ted
