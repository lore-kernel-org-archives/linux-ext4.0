From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: Replace hackish
	ext4_mb_poll_new_transaction with commit callback
Date: Fri, 17 Oct 2008 06:02:14 -0400
Message-ID: <20081017100214.GB11557@mit.edu>
References: <1224201763-9637-1-git-send-email-tytso@mit.edu> <20081017060424.GA26192@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35057 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752036AbYJQKCS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 06:02:18 -0400
Content-Disposition: inline
In-Reply-To: <20081017060424.GA26192@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 17, 2008 at 11:34:25AM +0530, Aneesh Kumar K.V wrote:
> 
> Why not use journal commit callback patch from andreas 
> (MID:20080929201752.GN10950@webber.adilger.int
> http://article.gmane.org/gmane.comp.file-systems.ext4/9148)
> 
> The patch you sent will allows only one call back to be registered.
> 

Thanks for reminding me about that; I had completely forgotten about
Andreas' patch.  Sure, I'll respin the patch to use his extension.

	 	       	    	       	     	- Ted
