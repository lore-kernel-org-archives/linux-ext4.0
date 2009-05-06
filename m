From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ext4/jbd2: remove stray markers
Date: Wed, 6 May 2009 15:18:24 +0200
Message-ID: <20090506131824.GB1325@elte.hu>
References: <20090506104436.GA24047@lst.de> <20090506110354.GG25203@elte.hu> <20090506114051.GA4964@mit.edu> <20090506114415.GA26947@lst.de> <20090506125552.GD4964@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org,
	Fr?d?ric Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-ext4
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:53078 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZEFNSj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2009 09:18:39 -0400
Content-Disposition: inline
In-Reply-To: <20090506125552.GD4964@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Theodore Tso <tytso@mit.edu> wrote:

> On Wed, May 06, 2009 at 01:44:15PM +0200, Christoph Hellwig wrote:
> > On Wed, May 06, 2009 at 07:40:51AM -0400, Theodore Tso wrote:
> > > My complaint with Cristoph's
> > 
> > Christoph, still :)
> 
> Sorry, I keep making that mistake!  Keep calling me on it, and
> eventually I'll reprogram those finger macros.  :-)
> 
> 
> > Also without Steve's updates you can't actually use them in a module.
> 
> Yep; not sure *how* critical that would be for -next, though. 
> Probably there would be some complaints....
> 
> In any case, it'll be less work to worry about patch conflicts if 
> we just do it during the merge window.  If we can just arrange to 
> push the tip/tracing changes early, I'll push the marker 
> replacement patches as soon as I see them hit mainline.

Cool, thanks! I'll try to aim for an early merge of the tracing 
tree. (And such dependent patches are generally possible shortly 
after -rc1 as well, especially if the clean-up factor is 
significant.)

	Ingo
