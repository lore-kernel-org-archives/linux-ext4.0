From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ext4 crypto: Do not select from EXT4_FS_ENCRYPTION
Date: Mon, 4 May 2015 09:00:16 +0800
Message-ID: <20150504010016.GA23560@gondor.apana.org.au>
References: <20150501001855.GA31516@gondor.apana.org.au>
 <554615C6.1060107@iki.fi>
 <20150503175320.GI10014@thunk.org>
 <554668EE.4000808@iki.fi>
 <20150503211118.GK10014@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anssi Hannula <anssi.hannula@iki.fi>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38323 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbbEDBAt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 May 2015 21:00:49 -0400
Content-Disposition: inline
In-Reply-To: <20150503211118.GK10014@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 03, 2015 at 05:11:18PM -0400, Theodore Ts'o wrote:
>
> Thanks for pointing out problem in the commit message.  I guess I
> wasn't reading all that carefully, but started experimenting, and came
> up with some case where, if they aren't lack _bugs_, do constrain
> flexibility a little.  You are correct that various crypto modules can
> still be built as modules even if ext4 is a module and
> EXT4_FS_ENCRYPTION is 'y'.  The main issue that I was able to find is
> that if ext4 is _not_ a module, then it also forces the crypto modules
> to also be built in.

Sorry for the confusion.  Please just revert my patch.

I was trying to figure out what was causing various crypto modules
to be built-in in my test config and this was the latest change that
*looked* as if it might have caused my problem.  Obviously I didn't
test it properly after making that change.

It should just be reverted because if ext4 was built-in then you
do want to have the crypto stuff built-in just in case the root fs
was encrypted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
