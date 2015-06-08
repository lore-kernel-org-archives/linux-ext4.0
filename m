From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4 crypto: handle ENOKEY correctly
Date: Mon, 8 Jun 2015 11:55:35 -0400
Message-ID: <20150608155535.GG19168@thunk.org>
References: <1432917543-26495-1-git-send-email-dmonakhov@openvz.org>
 <20150529204429.GH18540@thunk.org>
 <20150531150342.GB11642@thunk.org>
 <87bngz92c1.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: G@thunk.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53135 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbbFHPzj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 11:55:39 -0400
Content-Disposition: inline
In-Reply-To: <87bngz92c1.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 01, 2015 at 12:59:10PM +0300, Dmitry Monakhov wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
> 
> > On Fri, May 29, 2015 at 04:44:29PM -0400, Theodore Ts'o wrote:
> >> I don't think that's the right way to go.  We should add checks to
> >> ext4_file_open, sure.  But the problem is that i_crypt_info can get
> >> set to NULL after the file is succesfully opened.  So we need to
> >> handle i_crypt_info being NULL everywhere.  So the BUG_ON() in
> >> ext4_get_crypto_ctx() needs to be replaced with:
> >> 
> >> 	if (ci == NULL)
> >> 		return ERR_PTR(-ENOKEY);
> >
> > This is what I had in mind....
> ACK. with one note, you forget to convert all callers of
> ext4_get_crypto_ctx() to new error convention. Please see patch below.

Thanks for pointing that out!  Fixed.

					- Ted
