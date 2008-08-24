From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] debugfs : Close the file handle and return in case of
	errors.
Date: Sat, 23 Aug 2008 23:15:51 -0400
Message-ID: <20080824031551.GA1408@mit.edu>
References: <ea11fea30808230911s74d94a8ancee99cfe4bc46e22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42785 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751837AbYHXDPx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2008 23:15:53 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30808230911s74d94a8ancee99cfe4bc46e22@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 23, 2008 at 09:41:25PM +0530, Manish Katiyar wrote:
> Close the filehandle and return in case if we are unable to expand the
> directory during write.

Thanks, applied.

					- Ted
