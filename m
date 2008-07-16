From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs : Fix typo in function names in
	libext2fs.texinfo
Date: Tue, 15 Jul 2008 21:37:09 -0400
Message-ID: <20080716013709.GN8185@mit.edu>
References: <ea11fea30807151208m419892b3md4893612aa86b6f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45998 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751321AbYGPBhK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 21:37:10 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30807151208m419892b3md4893612aa86b6f8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 16, 2008 at 12:38:40AM +0530, Manish Katiyar wrote:
> Fix the function names mentioned in libext2fs documentation.

Thanks, applied.

BTW, in the future, I'd appreciate it if you don't include a
separating line made with equal characters between the patch
description and the Signed-off-by:

>
> ==================================================================
>

Also, your mail reader seems to be corrupting patches by line-wrapping
them at around 72 colums (i.e., adding new-lines to break up long
lines in the patch).  I had to manually fix up your patch so it would
be accepted.

Could you look into changing the settings of your mail program?

Thanks for doing all of your patches!!

       	   	 				- Ted
