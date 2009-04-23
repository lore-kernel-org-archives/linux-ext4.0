From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Make the extent validity check more paranoid
Date: Thu, 23 Apr 2009 00:19:14 -0400
Message-ID: <20090423041914.GA2723@mit.edu>
References: <1240450174-25868-1-git-send-email-tytso@mit.edu> <49EFCCAE.6050602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44140 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbZDWETW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Apr 2009 00:19:22 -0400
Content-Disposition: inline
In-Reply-To: <49EFCCAE.6050602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 22, 2009 at 09:04:30PM -0500, Eric Sandeen wrote:
> Theodore Ts'o wrote:
> > Instead of just checking that the extent block number is greater or
> > equal than s_first_data_block, make sure it it is not pointing into
> > the block group descriptors, since that is clearly wrong.  This helps
> > prevent filesystem from getting very badly corrupted in case an extent
> > block is corrupted.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Good idea.  Maybe we can get our friends with the corrupted fs to run
> with these validation patches... I can get this into rawhide at least.

Yeah, unfortunately this patch requires some other patches that went
in during the 2.6.30 merge window, so some extra back-porting would be
needed for our friends running a 2.6.29.1 Fedora kernel.

I'm still trying figure out what's the best way to add the right kind
of checking for 2.6.29 based kernels.  Looking at the dump files which
Kevin Shanahan, it doesn't look like they are coming from interior
nodes of extent trees.  Some kind of kludge patch into the block
device layer might be the most fool-proof way to do things.

       	     	      	       		  - Ted
