From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] jbd: fix fsync() tid wraparound bug
Date: Mon, 2 May 2011 17:31:13 -0400
Message-ID: <20110502213113.GI2819@thunk.org>
References: <20110425231454.GB9486@thunk.org>
 <1303777411-1316-2-git-send-email-tytso@mit.edu>
 <20110430171711.GA2819@thunk.org>
 <20110502150758.GH4556@quack.suse.cz>
 <20110502182945.GG2819@thunk.org>
 <20110502190441.GK4556@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Martin_Zielinski@McAfee.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44670 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab1EBVbS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 17:31:18 -0400
Content-Disposition: inline
In-Reply-To: <20110502190441.GK4556@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2011 at 09:04:41PM +0200, Jan Kara wrote:
>   Ah, OK. I didn't know it's so many reports. Indeed it looks like there's
> another bug. But then the WARN you have added should tell us more about
> who's causing the problem, right?

That's the hope.  I'm not sure WARNs get logged in Android's reporting
system.  I need to work the Android folks to figure this out.  Worst
case I may have to turn the WARN into a BUG for them (although it may
be tough to convince them to make such a change).  I'm hoping though
that the debugging information from Martin's machines will also come
through with some useful information that will allow us to root cause
whatever is causing this to happen.

							- Ted
