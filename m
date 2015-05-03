From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 crypto: Do not select from EXT4_FS_ENCRYPTION
Date: Sun, 3 May 2015 13:53:20 -0400
Message-ID: <20150503175320.GI10014@thunk.org>
References: <20150501001855.GA31516@gondor.apana.org.au>
 <554615C6.1060107@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42170 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbbECRx0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 May 2015 13:53:26 -0400
Content-Disposition: inline
In-Reply-To: <554615C6.1060107@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 03, 2015 at 03:34:14PM +0300, Anssi Hannula wrote:
> Hi,
> 
> 01.05.2015, 03:18, Herbert Xu kirjoitti:
> > This patch adds a tristate EXT4_ENCRYPTION to do the selections
> > for EXT4_FS_ENCRYPTION because selecting from a bool causes all
> > the selected options to be built-in, even if EXT4 itself is a
> > module.
> 
> Hmm, are you sure?
> 
> Since CONFIG_EXT4_FS_ENCRYPTION itself depends on CONFIG_EXT4_FS, the
> selector for the selected options becomes (CONFIG_EXT4_FS_ENCRYPTION &&
> CONFIG_EXT4_FS && CONFIG_BLOCK).
> 
> Per my testing on git master (without this patch), if EXT4_FS=m and
> EXT4_FS_ENCRYPTION=y, both "built-in" and "module" options are allowed
> for the selected options (checked CONFIG_ENCRYPTED_KEYS myself).

I believe the situation which is causing concern is when someone wants
to build a kernel where EXT4_FS=y, but they want the cryptographic
algorithms to be modules.  In that case, since EXT4_FS_ENCRYPTION is
'y', it forces the all of the crypto modules to be built into the
kernel, and so it forecloses that option from someone who is building
or packaging a kernel.

	       		   	     - Ted
