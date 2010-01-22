From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH v4 0/3] dioread_nolock patch
Date: Fri, 22 Jan 2010 15:47:15 -0500
Message-ID: <20100122204715.GA6781@shell>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu> <4B50C78D.2000807@redhat.com> <20100115201521.GE7256@thunk.org> <4B50CD5B.9050804@redhat.com> <532480951001151347w2f1bf2b2j34bb88b58a766f9c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Jiaying Zhang <jiayingz@google.com>, tytso@mit.edu,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab0AVUrV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2010 15:47:21 -0500
Content-Disposition: inline
In-Reply-To: <532480951001151347w2f1bf2b2j34bb88b58a766f9c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 15, 2010 at 01:47:26PM -0800, Michael Rubin wrote:
> On Fri, Jan 15, 2010 at 12:17 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > tytso@mit.edu wrote:
> > At one point google was planning to devise a power-fail test
> > harness. ?Any news on that?
> 
> We completed the tests. But there is good news and bad news. The good
> news is that we were able to shake out a lot of bugs in the no journal
> case (which have already been submitted upstream). We now can fairly
> quickly and easily drive a lot of traffic to a system and then cut the
> power, issue a panic or other event.
> 
> The bad news is that I was hoping to use open source tools to drive
> the traffic. The goal would be to allow everyone to reproduce the
> experiment. We got a little short handed on resources and ended up
> using Google closed source workloads instead. This was mostly since we
> were in a rush and able to get the network traffic up in one day with
> those tools.
> 
> I was holding back on publishing the results since I was hoping we
> would be able to generate traffic in a more open manner. But if you
> are interested in the results anyway then give me or some one on the
> team a day or two to dig them up.

Don't let the perfect be the enemy of the good. :) I'd love to see
what you've got now, even if you have to leave out the closed part of it.

-VAL

> In any case we have powerfail testing as part of our validation and
> once Jiayingz is satisfied with the patch we will be running those
> tests.
> 
> mrubin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
