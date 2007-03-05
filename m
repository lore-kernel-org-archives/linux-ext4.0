From: Daniel Drake <ddrake@brontes3d.com>
Subject: Re: e2fsck and human intervention
Date: Mon, 05 Mar 2007 12:01:36 -0500
Message-ID: <1173114096.8644.5.camel@systems03.mmm.com>
References: <1173112017.6300.14.camel@systems03.mmm.com>
	 <20070305164847.GB9444@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp126.iad.emailsrvr.com ([207.97.245.126]:42448 "EHLO
	smtp126.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbXCERBh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2007 12:01:37 -0500
In-Reply-To: <20070305164847.GB9444@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

Thanks for the quick response.

On Mon, 2007-03-05 at 11:48 -0500, Theodore Tso wrote:
> Actually, power loss by itself should *not* cause any corruption when
> you are using ext3; that's the whole point of the journal.  If there
> is, you probably have some other problem that you might do well to try
> to debug before youi ship your product, since that may lead to
> significant data loss in the long-term.

OK. I do need to do further testing to see how well the system copes in
situations like this, understanding e2fsck's behaviour is just a
starting point.

In the quoted section above, do you regard 'preen-mode not automatically
fixing everything' and 'corruption' as the same? i.e. are you saying
that the "UNEXPECTED INCONSISTENCY" error message should never appear
after an unexpected power loss? Alternatively, in which kinds of
situations would you reasonably expect preen mode to not be able to
automate all the repairs?

I realise that I mentioned corruption in my last mail, but actually I
don't think we have really seen any of that. Instead the biggest issue
right now is e2fsck halting system boot, and I definitely have seen this
happen a few times (even if no damage was observed after re-running fsck
with -y)

Thanks.

-- 
Daniel Drake
Brontes Technologies, A 3M Company
