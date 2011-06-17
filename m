From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function
 get_fragment_score()
Date: Thu, 16 Jun 2011 23:18:14 -0400
Message-ID: <20110617031814.GA31884@thunk.org>
References: <4DF8522F.2020304@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50052 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab1FQDSS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2011 23:18:18 -0400
Content-Disposition: inline
In-Reply-To: <4DF8522F.2020304@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 15, 2011 at 03:33:19PM +0900, Kazuya Mio wrote:
> This patch adds get_fragment_score() to libe2p. get_fragment_score() returns
> the fragmentation score. It shows the percentage of extents whose size is
> smaller than the input argument "threshold".

It perhaps might be useful to also articulate what are the goals of
this metric.  Is just just to decide which files should be
defragmented, and which should be left alone?  Or do you want to be
able to compare which file is "worse off"?

I can imagine two files that have a score of 100%, but one is much
worse off than the other.  Does that matter?  It may or might not,
depending how you plan to use the fragmentation score, both now and in
the future.  So it might be good to explicitly declare what are the
goals for this metrics, and its planned use cases.

Regards,

						- Ted
