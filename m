From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [BUG] xfstests #68 with data=journal hang against 3.8-rc7 and
 'dev' branch
Date: Tue, 19 Feb 2013 01:33:26 +0800
Message-ID: <20130218173326.GB3056@gmail.com>
References: <20130217172208.GB4059@gmail.com>
 <20130218050422.GD10361@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65329 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab3BRRSq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2013 12:18:46 -0500
Received: by mail-pa0-f47.google.com with SMTP id bj3so2877504pad.20
        for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2013 09:18:45 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130218050422.GD10361@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2013 at 12:04:22AM -0500, Theodore Ts'o wrote:
> On Mon, Feb 18, 2013 at 01:22:08AM +0800, Zheng Liu wrote:
> > Hi all,
> > 
> > Xfstests #68 will hang with data=journal in 3.8-rc7 and 'dev' branch. I
> > remember that there has a patch for ext4 to fix filesystem freeze bug
> > but I am not sure whether it can fix this bug and it has been applied
> > into 'dev' branch.  So I file this bug here.
> 
> Hmm.... I have never seen this test fail with my tests (although I'm
> just using the dev branch; I have not tried merging in 3.8-rc7 into
> the dev branch for any of my tests).
> 
> Is it failing for you reliably?

I dig this bug again and I always reproduce it in my own machine with
SSD disk in 3.8-rc7 and dev branch.  But, interestingly, I run the same
test case in another machine, which is the same as previous one except
that it only has a HDD, and I never trigger this bug.  So it seems that
this bug could be triggered in a high-speed device, but we need to
verify this conclusion.  Sorry I haven't another server with SSD/Flash
device to run test case.  That would be great if others could give it a
try.

Thanks,
                                                - Zheng
