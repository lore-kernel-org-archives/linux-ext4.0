From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: jbd2 batch time tuning behavior question
Date: Mon, 2 Jun 2014 10:42:10 -0400
Message-ID: <20140602144210.GC30598@thunk.org>
References: <5384C18A.7040501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45566 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbaFBOmM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2014 10:42:12 -0400
Content-Disposition: inline
In-Reply-To: <5384C18A.7040501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 27, 2014 at 11:47:06AM -0500, Eric Sandeen wrote:
> 
> Docs say "0" turns it off, but option handling turns "0" into 
> EXT4_DEF_MAX_BATCH_TIME.  What was the real intent here; should the
> docs or the behavior be changed?

Nice catch!  I would think it's probably better if we make the
behavior change to match the docs.

Want to send a patch, since you found the problem, or shall I create a
patch myself to fix things up?

Thanks,

     	       	      	       	      	  - Ted
