From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH]JBD2/JBD: race condition while writing updates to
	journal
Date: Thu, 16 Jul 2009 21:36:12 -0400
Message-ID: <20090717013612.GF8508@mit.edu>
References: <4A3F3B32.9090606@gmail.com> <20090715144729.GC22826@atrey.karlin.mff.cuni.cz> <20090715181343.GF22826@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dingdinghua@nrchpc.ac.cn,
	dingdinghua <dingdinghua85@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59181 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933916AbZGQBgQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2009 21:36:16 -0400
Content-Disposition: inline
In-Reply-To: <20090715181343.GF22826@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 15, 2009 at 08:13:43PM +0200, Jan Kara wrote:
> >   Ted, I don't think this got merged...
>   Ah, I see, jbd2 part got merged by you, I'm not sure about the jbd
> part since I didn't see Andrew reply. I guess I'll create a tree for
> ext3/jbd changes and merge this patch (and other ext3/jbd fixes I have
> here) through it.

I did get a note from Andrew saying he had grabbed the patch.  It
probably hasn't been published in his mmotm tree yet.

	 	     	       	      	    - Ted
