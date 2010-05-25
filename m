From: tytso@mit.edu
Subject: Re: [PATCH 1/2] ext4: Conditionally define compat ioctl numbers
Date: Tue, 25 May 2010 11:22:19 -0400
Message-ID: <20100525152219.GM5556@thunk.org>
References: <1274398223.2257.0.camel@localhost>
 <20100525151548.GL5556@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50381 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090Ab0EYPWZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 11:22:25 -0400
Content-Disposition: inline
In-Reply-To: <20100525151548.GL5556@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 25, 2010 at 11:15:48AM -0400, tytso@MIT.EDU wrote:
> On Fri, May 21, 2010 at 12:30:22AM +0100, Ben Hutchings wrote:
> > It is unnecessary, and in general impossible, to define the compat
> > ioctl numbers except when building the filesystem with CONFIG_COMPAT
> > defined.
> 
> Umm.... why?  (The impossible part)  I think I'm missing something here.
> 

Oh, right.  The type widths might not be guaranteed (or even defined).
Never mind...

    	    	     	    	      	 	    	- Ted
