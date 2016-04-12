From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: make it possible to interrupt initial readdir call
Date: Mon, 11 Apr 2016 21:35:03 -0400
Message-ID: <20160412013503.GG7369@thunk.org>
References: <20160302171511.GM12913@kvack.org>
 <20160302214330.GB24012@thunk.org>
 <20160314175732.GL17923@kvack.org>
 <20160408181841.GI8871@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41210 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbcDLBfF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Apr 2016 21:35:05 -0400
Content-Disposition: inline
In-Reply-To: <20160408181841.GI8871@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 08, 2016 at 02:18:41PM -0400, Benjamin LaHaise wrote:
> No response on this patch yet....  Given that it's clearly a bug, and we've 
> got a test case that reproduces it, why isn't this being applied?

Sorry, I forgot to ack the your patch.  I did apply it and it went to
Linus during the merge window.  Unfortunately, it casued a regression,
and Linus reverted it.  What went to Linus was changed slightly,
because I was trying to fix another potential case where we could end
up looping for a very long time.  Unfortunately I screwed up the
modification patch and the regression tests didn't catch the problem.

	     	       	   	      	    	   - Ted
