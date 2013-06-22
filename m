From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 file replace guarantees
Date: Sat, 22 Jun 2013 10:06:13 -0400
Message-ID: <20130622140613.GE4727@thunk.org>
References: <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <20130621143347.GF10730@thunk.org>
 <1371828285.23425.140661246894093.6DC945E0@webmail.messagingengine.com>
 <20130621203547.GA10582@thunk.org>
 <20130622032944.GX29376@dastard>
 <20130622044718.GC4727@thunk.org>
 <C0F0BC787567C848B2C90989451123DA2363CBBE@ATLEXMBX4.ARRS.ARRISI.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Ryan Lortie <desrt@desrt.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60263 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab3FVOGT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Jun 2013 10:06:19 -0400
Content-Disposition: inline
In-Reply-To: <C0F0BC787567C848B2C90989451123DA2363CBBE@ATLEXMBX4.ARRS.ARRISI.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 22, 2013 at 01:40:26PM +0000, Sidorov, Andrei wrote:
> Me too, but people have to do that because fs api is too generic and
> at the same time one has to account fs specifics in order to make
> their app take most advantage or at least to avoid inefficiencies.
> For example I have an app that constantly does appending writes to
> about 15 files and I must ensure that no more than 5 seconds will be
> lost in an event of system crash or power loss.

Stop right there.  If you are doing lots of appending writes, and you
dont want to lose no more than 5 seconds, why do you have 15 files?
Why send your appending writes into a single file and then later on,
disaggregate out the logs when you need to read them?  With 15 files,
no matter what you are doing, you will be forcing the heads to seek
all over the place, and since the 4k blocks won't be full when you
sync them, you're wasting write cycles and disk bandwidth.

See what I mean?  There's a reason why I said the fault was
incompetent application design, not just incomplement implementation.

	    			    	 	      - Ted
