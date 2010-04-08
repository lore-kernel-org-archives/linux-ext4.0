From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Thu, 8 Apr 2010 10:17:41 -0400
Message-ID: <20100408141741.GD10879@redhat.com>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com> <20100407214631.GL3206@redhat.com> <20100408110442.GK10103@kernel.dk> <20100408140515.GB10879@redhat.com> <20100408140944.GQ10103@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab0DHOSD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 10:18:03 -0400
Content-Disposition: inline
In-Reply-To: <20100408140944.GQ10103@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 08, 2010 at 04:09:44PM +0200, Jens Axboe wrote:

[..]
> Precisely. The next question would be how to control the yielding. In
> this particular case, you want to be yielding to a specific cfqq. IOW,
> you essentially want to pass your slide on to that queue. The way the
> above is implemented, you could easily just switch to another unrelated
> queue. And if that is done, fairness is skewed without helping the
> yielding process at all (which was the intention).
> 

True. I guess this is relatively simple yield implementation where we are
telling IO scheduler that there is no more IO coming on this context so
don't waste time idling. That's a different thing that after giving up
slice, cfq might schedule in another sequential reader instead of
journalling thread.

Ideally it would be better to be also able to specify who to transfer
remaining slice to. I am not sure if there is an easy way to pass this
info CFQ.

So this implementation might be good first step.

Vivek
