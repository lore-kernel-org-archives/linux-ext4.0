From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: use percpu counter for extent cache count
Date: Mon, 4 Mar 2013 00:39:41 +0800
Message-ID: <20130303163940.GA30459@gmail.com>
References: <20130227191923.GA1121@redhat.com>
 <20130227192907.GB14253@thunk.org>
 <20130227201217.GD14253@thunk.org>
 <20130301033005.GA7081@redhat.com>
 <20130301040039.GA4452@thunk.org>
 <20130301050029.GB4452@thunk.org>
 <5130DA71.4040808@redhat.com>
 <20130301180035.GB17920@thunk.org>
 <5130ED3A.30003@redhat.com>
 <20130302152644.GA22941@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Dave Jones <davej@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:39674 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab3CCQYk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Mar 2013 11:24:40 -0500
Received: by mail-da0-f49.google.com with SMTP id t11so2149916daj.36
        for <linux-ext4@vger.kernel.org>; Sun, 03 Mar 2013 08:24:40 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130302152644.GA22941@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 02, 2013 at 10:26:44AM -0500, Theodore Ts'o wrote:
> On Fri, Mar 01, 2013 at 12:02:34PM -0600, Eric Sandeen wrote:
> > 
> > I was mostly keying off what quota felt was best, I guess.
> > I'm not wedded to either approach, it was just a thought.
> > So you can take it or leave it. :)
> 
> I'll take it, but for the record, there's a reason why I label patches
> with "I haven't tested this yet" disclaimers.
> 
> For future reference, calling percpu_counter_init() and
> percpu_counter_destroy() is not optional --- without them, in your
> original patch, the kernel will crash them the first time an ext4 file
> system mount is attempted.
> 
> No worries though, no harm done --- but it's better if people don't
> rely on me to catch bugs before they go into the tree.  :-)

Really sorry for the delay reply.

Dave, thank you very much for your test and reporting this regression.

Ted, Eric, thank you very much for fixing it.  

I really think I need to be responsible for reviewing and testing this
patch because I screw it up.  My apology.

Thanks,
                                                - Zheng
