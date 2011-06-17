From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Fri, 17 Jun 2011 09:20:55 -0500
Message-ID: <4DFB62C7.5070008@redhat.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab1FQOVA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jun 2011 10:21:00 -0400
In-Reply-To: <20110617031814.GA31884@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/16/11 10:18 PM, Ted Ts'o wrote:
> On Wed, Jun 15, 2011 at 03:33:19PM +0900, Kazuya Mio wrote:
>> This patch adds get_fragment_score() to libe2p. get_fragment_score() returns
>> the fragmentation score. It shows the percentage of extents whose size is
>> smaller than the input argument "threshold".
> 
> It perhaps might be useful to also articulate what are the goals of
> this metric.  Is just just to decide which files should be
> defragmented, and which should be left alone?  Or do you want to be
> able to compare which file is "worse off"?
> 
> I can imagine two files that have a score of 100%, but one is much
> worse off than the other.  Does that matter?  It may or might not,
> depending how you plan to use the fragmentation score, both now and in
> the future.  So it might be good to explicitly declare what are the
> goals for this metrics, and its planned use cases.
> 
> Regards,

Just as a random datapoint, the xfs_db "frag factor" has been a constant
source of misunderstanding and woe for us.  (Granted, it works differently;
it is an fs-wide number representing

	((actual - ideal) / actual)

extents in the fs.)

This "% of fragments smaller than threshold" is more easily understandable
and possibly more descriptive, but I think Ted makes good points;
think about how this will be used, and whether the metric is useful.

It's hard to make a single number a) make sense to the user, and b)
be usefully representative of fragmentation "badness" - so I am
feeling very cautious about this idea overall.

To really convey fragmentation "badness" you'd almost want a histogram
of fragment sizes, which is a bit hard to present concisely...


-Eric

> 						- Ted

