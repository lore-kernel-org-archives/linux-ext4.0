From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: fix delalloc retry loop logic v2
Date: Wed, 3 Feb 2010 16:16:26 -0500
Message-ID: <20100203211626.GI16384@thunk.org>
References: <87zl3qrwnx.fsf@openvz.org>
 <87sk9irve0.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57665 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300Ab0BCVQ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Feb 2010 16:16:28 -0500
Content-Disposition: inline
In-Reply-To: <87sk9irve0.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 03, 2010 at 10:07:03PM +0300, Dmitry Monakhov wrote:
> Dmitry Monakhov <dmonakhov@openvz.org> writes:
> 
> > Theodore please review this patch ASAP, currently ext4+quota is 
> > fatally broken due to your patch. Christmas holidays when you
> > submit your patch is not good time for good review, IMHO
> > i was too lazy to review it carefully.
> > Testcase is trivial it is enough just hit a quota barrier.
> > dmon$ set-quota-limit /mnt id=dmon --bsoft=1000 --bsoft=1000
> > dmon$ dd if=/dev/zefo of=/mnt/file 

Sorry, I had to submit 0637c6f somewhat in a hurry because commit
d21cd8f (your patch) was causing a rather large number of failures
that users were complaining about.  In retrospect maybe I should have
just backed out d21cd8f entirely and tried to sort out this whole mess
before the next merge window.

OK, I'll look this over as soon as I can.

    	      	   	   	     - Ted
