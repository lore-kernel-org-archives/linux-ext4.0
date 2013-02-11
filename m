From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 xfstests-bld results for 3.8-rc6 on Pandaboard ES
Date: Sun, 10 Feb 2013 22:48:18 -0500
Message-ID: <20130211034818.GB14298@thunk.org>
References: <20130207220536.GA16092@wallace>
 <20130208035547.GA19703@gmail.com>
 <20130211013523.GD10801@thunk.org>
 <20130211020836.GC13161@thunk.org>
 <20130211032451.GA14298@thunk.org>
 <4D4DE7C7-35AE-4D26-9283-DA489CC449A4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47833 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab3BKDsV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2013 22:48:21 -0500
Content-Disposition: inline
In-Reply-To: <4D4DE7C7-35AE-4D26-9283-DA489CC449A4@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 11, 2013 at 11:36:17AM +0800, gnehzuil.liu wrote:
> 
> Sorry, I haven't xfstests code in my hand, but I remember that #255
> is used to test hole punching feature.  So I suspect that no extents
> is the root cause because my patch set of indirect-based hole
> punching will cause it failed.

Ah, thanks for pointing that out.  I'll take a closer look tomorrow,
but I'm sure you're correct.

I hope you've been enojoying a good Chinese New Year's vacation;
thanks for checking in during your holiday.

Cheers,

						- Ted
