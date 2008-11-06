From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] imporve jbd2 fsync batching
Date: Thu, 6 Nov 2008 09:35:01 -0500
Message-ID: <20081106143459.GC18270@unused.rdu.redhat.com>
References: <20081104161024.GC28058@unused.rdu.redhat.com> <20081105231012.GJ3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33057 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbYKFOfi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Nov 2008 09:35:38 -0500
Content-Disposition: inline
In-Reply-To: <20081105231012.GJ3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 05, 2008 at 04:10:12PM -0700, Andreas Dilger wrote:
> On Nov 04, 2008  11:10 -0500, Josef Bacik wrote:
> > somebody does a sync write or an fsync() traditionally we would sleep for 1
> > jiffies, which depending on the value of HZ could be a significant amount of
> > time compared to how long it takes to commit a transaction to the underlying
> > storage.  With this patch instead of sleeping for a jiffie, we check to see if
> > the amount of time this transaction has been running is less than the average
> > commit time, and if it is we sleep for the delta using schedule_hrtimeout to
> > give us a higher precision sleep time.  This greatly benefits high end storage
> > where you could end up sleeping for longer than it takes to commit the
> > transaction and therefore sitting idle instead of allowing the transaction to
> > be committed by keeping the sleep time to a minimum so you are sure to always
> > be doing something.
> 
> There was no reply to my previous comments about making the maximum sleep
> time be a fixed value (e.g. 15ms) instead of having it arbitrarily based
> on the jiffies value, which may change between 1ms and 10ms.
> 
> I don't object to this being included in ext4, but I suspect it could do
> even better, or at least be more consistent than depending on the HZ value.
>

Sorry I missed that comment.  The reason I set the top to be 1 jiffies was
because thats what it used to be, so in an effort to try and keep regressions
from happening I just left it as the max.  I'm fine with setting the max to some
other more constant value.  Thanks,

Josef 
