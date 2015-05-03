From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 crypto: Do not select from EXT4_FS_ENCRYPTION
Date: Sun, 3 May 2015 17:11:18 -0400
Message-ID: <20150503211118.GK10014@thunk.org>
References: <20150501001855.GA31516@gondor.apana.org.au>
 <554615C6.1060107@iki.fi>
 <20150503175320.GI10014@thunk.org>
 <554668EE.4000808@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42352 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbbECVLV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 May 2015 17:11:21 -0400
Content-Disposition: inline
In-Reply-To: <554668EE.4000808@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 03, 2015 at 09:29:02PM +0300, Anssi Hannula wrote:
> > I believe the situation which is causing concern is when someone wants
> > to build a kernel where EXT4_FS=y, but they want the cryptographic
> > algorithms to be modules.  In that case, since EXT4_FS_ENCRYPTION is
> > 'y', it forces the all of the crypto modules to be built into the
> > kernel, and so it forecloses that option from someone who is building
> > or packaging a kernel.
> 
> Ah, OK, so not "EXT4 itself as a module" like the commit message said :)
> 
> For the situation you described I don't see a better solution either.

Thanks for pointing out problem in the commit message.  I guess I
wasn't reading all that carefully, but started experimenting, and came
up with some case where, if they aren't lack _bugs_, do constrain
flexibility a little.  You are correct that various crypto modules can
still be built as modules even if ext4 is a module and
EXT4_FS_ENCRYPTION is 'y'.  The main issue that I was able to find is
that if ext4 is _not_ a module, then it also forces the crypto modules
to also be built in.

(Personally from a performance perspective, I'd always want to make
the common crypto modules always built in to avoid pressure on the TLB
cache, but I understand that distributions seem to like to build
_everything_ as modules (which is one of the reasons why I generally
don't use distro kernels myself.  :-)

In any case, I'll correct the commit message so that it describes the
problem which it addresses more clearly.

							- Ted
