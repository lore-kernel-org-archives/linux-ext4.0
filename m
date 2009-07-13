From: Theodore Tso <tytso@mit.edu>
Subject: Re: Strange disk failure...could ext4 be the culprit?
Date: Mon, 13 Jul 2009 08:12:25 -0400
Message-ID: <20090713121225.GA25711@mit.edu>
References: <loom.20090707T173457-377@post.gmane.org> <20090713053520.GA5088@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Evan King <f11n1@unb.ca>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59741 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbZGMMMh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 08:12:37 -0400
Content-Disposition: inline
In-Reply-To: <20090713053520.GA5088@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 13, 2009 at 11:05:20AM +0530, Aneesh Kumar K.V wrote:
> > So my questions are these:
> > 
> >  - How likely is it that some arcane bug in ext4 is responsible for the failure?
> 
> Can you check whether your kernel have this patch
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ec0ae3acec47f628179ee95fe2c4da01b5e9fc4

And did you have multiple CPU's on the system which suffered the
problem?  (A requirement for this to have been the problem).

	     		     	     	       	   - Ted
