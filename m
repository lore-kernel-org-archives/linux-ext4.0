From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: trim unused params from
 convert_initialized_extent()
Date: Mon, 22 Feb 2016 22:59:34 -0500
Message-ID: <20160223035934.GI1215@thunk.org>
References: <20160120201923.GA2650@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39368 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757073AbcBWD7h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2016 22:59:37 -0500
Content-Disposition: inline
In-Reply-To: <20160120201923.GA2650@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 20, 2016 at 03:19:23PM -0500, Eric Whitney wrote:
> The flags and newblock parameters are unused.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

I've adjusted this patch to just remove the flags parameters (since
the newblock paramter was removed in another patch).

    	     	      	  	     - Ted
