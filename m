From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: make local functions static
Date: Mon, 12 May 2014 10:51:06 -0400
Message-ID: <20140512145106.GH31376@thunk.org>
References: <20131230212501.409767a0@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34725 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbaELOvJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 10:51:09 -0400
Content-Disposition: inline
In-Reply-To: <20131230212501.409767a0@nehalam.linuxnetplumber.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 30, 2013 at 09:25:01PM -0800, Stephen Hemminger wrote:
> I have been running make namespacecheck to look for unneeded globals, and
> found these in ext4.
> 
> In one case, the function order was swapped to avoid having to put
> in a forward declaration.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Thanks, applied (with a few minor adjustments since the code changed a
little since this patch was posted).  Thanks for sending the patch,
and my apologies for the delay in getting to it!

       		     	       	  	  - Ted
