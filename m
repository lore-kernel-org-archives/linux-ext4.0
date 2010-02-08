From: tytso@mit.edu
Subject: Re: [PATCH] obsolete config in kernel source (BUFFER_DEBUG)
Date: Mon, 8 Feb 2010 10:50:31 -0500
Message-ID: <20100208155031.GK4494@thunk.org>
References: <20100205131333.GB6540@faui49.informatik.uni-erlangen.de>
 <20100208135629.GD4321@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kazuo Moriwaka <moriwaka@redhat.com>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Joel Becker <joel.becker@oracle.com>,
	linux-ext4@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33122 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0BHPvT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 10:51:19 -0500
Content-Disposition: inline
In-Reply-To: <20100208135629.GD4321@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 08, 2010 at 02:56:29PM +0100, Jan Kara wrote:
> On Fri 05-02-10 14:13:33, Christoph Egger wrote:
> > Hi all!
> > 
> > 	As part of the VAMOS[0] research project at the University of
> > Erlangen we're checking referential integrity between kernel KConfig
> > options and in-code Conditional blocks.
> > 
> > 	With some commit somewhere around 2.4.15 the last hint of
> > CONFIG_BUFFER_DEBUG (apart from the 2 occurences this patch addresses)
> > -- some documentation -- was removed from the kernel source. However
> > this one piece of code made it till today. Time to go forward and
> > remove it?
> > 
> > 	Please keep me informed of this patch getting confirmed /
> > merged so we can keep track of it.
>   Thanks, the patch looks good. I've merged it into my linux-fs tree and
> will send it to Linus in the next merge window.

I don't have an objection with removing this, but does anyone have the
latest version of akpm's buffer debugging patches?

I *think* what happened is that akpm forward ported the removed buffer
debugging patches, or maybe rewrote it from scratch, but for whatever
reason they never made back into mainline.  Maybe they were too ugly
to live in mainline, but they have been really handy on occasion.

   	   	     	      	   	       - Ted
