From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Update maximum journal size in tune2fs man page
Date: Sat, 20 Jun 2015 15:43:37 -0400
Message-ID: <20150620194337.GH29480@thunk.org>
References: <1432414185-5997-1-git-send-email-psusi@ubuntu.com>
 <55821752.7090901@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46635 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbbFTTnj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Jun 2015 15:43:39 -0400
Content-Disposition: inline
In-Reply-To: <55821752.7090901@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 17, 2015 at 08:56:50PM -0400, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> On 05/23/2015 04:49 PM, Phillip Susi wrote:
> > The man page for tune2fs still listed the upper limit for the 
> > journal as 102,400 blocks.
> 
> Bump.

BTW, your patch was missing a Signed-off-by.  The change was small enough
that I let it go this time.

				- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
