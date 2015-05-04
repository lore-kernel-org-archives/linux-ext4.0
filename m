From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 crypto: Do not select from EXT4_FS_ENCRYPTION
Date: Sun, 3 May 2015 21:37:24 -0400
Message-ID: <20150504013724.GM10014@thunk.org>
References: <20150501001855.GA31516@gondor.apana.org.au>
 <554615C6.1060107@iki.fi>
 <20150503175320.GI10014@thunk.org>
 <554668EE.4000808@iki.fi>
 <20150503211118.GK10014@thunk.org>
 <20150504010016.GA23560@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anssi Hannula <anssi.hannula@iki.fi>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42481 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbbEDBh3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 May 2015 21:37:29 -0400
Content-Disposition: inline
In-Reply-To: <20150504010016.GA23560@gondor.apana.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 04, 2015 at 09:00:16AM +0800, Herbert Xu wrote:
> 
> Sorry for the confusion.  Please just revert my patch.
> 
> I was trying to figure out what was causing various crypto modules
> to be built-in in my test config and this was the latest change that
> *looked* as if it might have caused my problem.  Obviously I didn't
> test it properly after making that change.
> 
> It should just be reverted because if ext4 was built-in then you
> do want to have the crypto stuff built-in just in case the root fs
> was encrypted.

Whoops, I _just_ sent a pull request to Linus.  The patch as it stands
actually allows both behaviors, depending on whether you answer 'y' or
'm' to EXT4_ENCRYPTION question.  Given that one of the main purposes
of per-filesystem encryption is that we only have to encrypt the user
files, so the system files can remain unencrypted for performance
reasons[1], I can imagine scenarios where it's conceivable that
someone might want to keep the crypto as modules.  My main unhappiness
with the Kconfig option is that it's a bit user unfriendly/confusing
what it means for CONFIG_EXT4_ENCRYPTION to be 'y' versus 'm'.

So I may end up reverting it, but since I've already sent the pull
request to Linus, I'm going to sleep on this for a bit.

Cheers,
					- Ted

[1] Though not for Intel chips; Intel acceleration of AES is so fast
there you might as well encrypt everything; and for single-user
laptops I still recommend dm-crypt.  Unfortunately, there are some ARM
chips which either do not have hardware accelerated AES, or where
their hardware accleration is decidedly poor....
