From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ext4/jbd2: remove stray markers
Date: Wed, 6 May 2009 13:58:50 +0200
Message-ID: <20090506115850.GO25203@elte.hu>
References: <20090506104436.GA24047@lst.de> <20090506110354.GG25203@elte.hu> <20090506114051.GA4964@mit.edu> <20090506114415.GA26947@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	Fr?d?ric Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:36946 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZEFL7G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2009 07:59:06 -0400
Content-Disposition: inline
In-Reply-To: <20090506114415.GA26947@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Christoph Hellwig <hch@lst.de> wrote:

> I was planning to do make sure it's all gone.  Once we are into 
> the 2.6.31 merge dinwo I fear that the final patches will miss the 
> window due to all these interdependencies.  But Ingo didn't seem 
> to be too interested in taking the other patches that would be 
> required for it, so I guess I'll try to somehow get it done in the 
> merge window and otherwise we'll have to wait for 2.6.32.

Well, while coupling to lots of subsystems is natural for something 
as intrinsic as the tracing tree - still i dont want to over-do it. 
In little over a month these patches can go into their local 
subsystem trees, without any interactions with anything.

So the patches you did are nice - just (as it is usual with any core 
kernel tree) the logistics have to be planned carefully.

	Ingo
