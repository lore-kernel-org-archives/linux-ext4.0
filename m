From: tytso@mit.edu
Subject: Re: ext4 df free space reporting not reliable?
Date: Sun, 13 Jun 2010 14:58:59 -0400
Message-ID: <20100613185858.GB8055@thunk.org>
References: <20100613093807.GA31407@basil.fritz.box>
 <69DFE925-D32D-4CAA-B734-545DE0515FCE@mit.edu>
 <20100613103451.GF31464@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38918 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab0FMS7E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jun 2010 14:59:04 -0400
Content-Disposition: inline
In-Reply-To: <20100613103451.GF31464@basil.fritz.box>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 13, 2010 at 12:34:51PM +0200, Andi Kleen wrote:
> > Are you creating the files as root?  Sounds like the standard reserved
> > blocks behavior that's been around since ext3, ext2, BSD's ufs, etc...
> 
> Yes everything is root.
> 
> I would expect root df to not report the reservation. Is that not the case?

No, the reservation is always reported, regardless of which user ID is
executing the statfs(2) system call.  This has always been true, going
all the way back to BSD 4.3.

I could see the argument for doing this differently, but I could also
see that being very surprising for people to see different results
depending on whether they are running df from a setuid shell or not.
I'm not aware of any Unix system which has implemented the root-only
reservation system which has done this.

	    	    	   	     	  - Ted
