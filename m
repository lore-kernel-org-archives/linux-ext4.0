From: Theodore Tso <tytso@mit.edu>
Subject: Re: duplicate entries on ext3 when using readdir/readdir64
Date: Wed, 13 Aug 2008 22:58:21 -0400
Message-ID: <20080814025821.GA6469@mit.edu>
References: <1217583820.12454.20.camel@kannnix.a2x.lan.at> <20080801121658.GG8736@mit.edu> <1217933631.14552.45.camel@kannnix.a2x.lan.at> <20080806140722.GA14109@mit.edu> <170fa0d20808131421j3e4955dcra611509f1a094547@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Trauner <tt@it-austria.net>, linux-ext4@vger.kernel.org,
	ext3-users <ext3-users@redhat.com>
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34805 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763AbYHNC6Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 22:58:25 -0400
Content-Disposition: inline
In-Reply-To: <170fa0d20808131421j3e4955dcra611509f1a094547@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 05:21:20PM -0400, Mike Snitzer wrote:
> 
> The attached patch has served my employer (IBRIX) well for 2.5 years.
> It was only recently, when I re-raised this issue internally based on
> this thread, that a co-worker recalled the fix.
> 

The patch looks good.  Did someone raise it 2.5 years ago, and we
somehow dropped the ball, or did no one think to submit the patch
upstream?

Also, can I get a Signed-off-by: line for this patch?

Thanks!!

						- Ted
