From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 crypto: Do not select from EXT4_FS_ENCRYPTION
Date: Sat, 2 May 2015 09:40:29 -0400
Message-ID: <20150502134029.GB10014@thunk.org>
References: <20150501001855.GA31516@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40701 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbbEBNkf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 May 2015 09:40:35 -0400
Content-Disposition: inline
In-Reply-To: <20150501001855.GA31516@gondor.apana.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2015 at 08:18:55AM +0800, Herbert Xu wrote:
> This patch adds a tristate EXT4_ENCRYPTION to do the selections
> for EXT4_FS_ENCRYPTION because selecting from a bool causes all
> the selected options to be built-in, even if EXT4 itself is a
> module.

Thanks for pointing out the problem!

This certainly fixes the problem, but it's a bit confusing; if you
answer "y" instead of "m" to the question, it will force the crypto
mechanisms to be built-in, and that's not necessarily obvious.  That
being said, I suspect the people who will care the most about this
will be people building the distro kernels, and it will hopefully be
obvious to them.

In any case, I can't find a better way of doing this, so thanks,
applied.  I'll get this  pushed to Linus ASAP.

	       	   	 	   - Ted
