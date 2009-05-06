From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4/jbd2: remove stray markers
Date: Wed, 6 May 2009 08:55:52 -0400
Message-ID: <20090506125552.GD4964@mit.edu>
References: <20090506104436.GA24047@lst.de> <20090506110354.GG25203@elte.hu> <20090506114051.GA4964@mit.edu> <20090506114415.GA26947@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Fr?d?ric Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33977 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357AbZEFM4I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2009 08:56:08 -0400
Content-Disposition: inline
In-Reply-To: <20090506114415.GA26947@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 06, 2009 at 01:44:15PM +0200, Christoph Hellwig wrote:
> On Wed, May 06, 2009 at 07:40:51AM -0400, Theodore Tso wrote:
> > My complaint with Cristoph's
> 
> Christoph, still :)

Sorry, I keep making that mistake!  Keep calling me on it, and
eventually I'll reprogram those finger macros.  :-)


> Also without Steve's updates you can't actually use them in a module.

Yep; not sure *how* critical that would be for -next, though.
Probably there would be some complaints....

In any case, it'll be less work to worry about patch conflicts if we
just do it during the merge window.  If we can just arrange to push
the tip/tracing changes early, I'll push the marker replacement
patches as soon as I see them hit mainline.

Regards,

						- Ted
