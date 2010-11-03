From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH -BUGFIX] Re: BUG in ext4 with 2.6.37-rc1
Date: Wed, 3 Nov 2010 14:22:29 -0400
Message-ID: <20101103182229.GA8766@elliptictech.com>
References: <20101102202013.GA3861@elliptictech.com>
 <20101103181412.GH25614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:55269 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752115Ab0KCSWt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Nov 2010 14:22:49 -0400
Content-Disposition: inline
In-Reply-To: <20101103181412.GH25614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-03 14:14 -0400, Ted Ts'o wrote:
> On Tue, Nov 02, 2010 at 04:20:13PM -0400, Nick Bowler wrote:
> > The following BUG occurred today while compiling gcc, with 2.6.37-rc1+.
> > More precisely, commit 7fe19da4ca38 ("preempt: fix kernel build with
> > !CONFIG_BKL") with http://permalink.gmane.org/gmane.linux.nfs/36521
> > applied on top.  It basically took out the whole system.
> 
> Hi Nick,
> 
> How easily can you reproduce this bug?  I'm pretty sure I know what
> caused it, but it's always good to get confirmation that a patch
> addresses the reported bug.  If it happens to you fairly often, can
> you try out this patch and let me know whether it fixes the bug for
> you?

I only encountered it the one time, but I haven't tried compiling gcc
since it blew up the first time (there seems to be no problem compiling
linux, for instance).  I will try it again now with and without the
patch.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
