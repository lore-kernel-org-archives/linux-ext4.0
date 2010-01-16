From: tytso@mit.edu
Subject: Re: Question about ext4 online defrag test case
Date: Sat, 16 Jan 2010 01:29:31 -0500
Message-ID: <20100116062930.GB25273@thunk.org>
References: <4B4EEF94.5000902@rs.jp.nec.com>
 <87f94c371001141304n18bcd208kd97f08646d37d1e2@mail.gmail.com>
 <37d33d831001150541o1b674580u14719e72e3ad8e78@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: SandeepKsinha <sandeepksinha@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40136 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab0APG3j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Jan 2010 01:29:39 -0500
Content-Disposition: inline
In-Reply-To: <37d33d831001150541o1b674580u14719e72e3ad8e78@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 15, 2010 at 07:11:28PM +0530, SandeepKsinha wrote:
> >> I found your comment about ext4 online defrag on Ubuntu BBS by accident.
> >> https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/321528
> >>
> >> I would like to address this problem so I ran e4defrag on the system
> >> which was under memory pressure. But unfortunately I could not find the bug.
> >> If you have already known how to reproduce this kind of problem,
> >> could you teach me how?

I'm sorry I wasn't clear.  I don't know of any specific problem with
the code, but I and some other ext4 developers remain a bit conerned
about the code because of how it is structured, and the fact that
there is so much code and there hasn't been a lot of people spent a
lot of time going through it and cleaning it up.  We also don't have
good regression tests for the kernel defrag support code.

This is partially my fault; I haven't had enough time to do more
testing and code clean up on the defrag code.  I need to spend more
time doing some testing and code cleanup before I'll be comfortable
telling people that it is as reliable as other parts of ext4 in terms
of not potentially losing their data.  Maybe it's just my paranoia....

       		   	  	       	     	  - Ted
