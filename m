From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Sat, 18 Jun 2011 01:19:47 -0600
Message-ID: <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org> <4DFB62C7.5070008@redhat.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>, Kazuya Mio <k-mio@sx.jp.nec.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57712 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab1FRHTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jun 2011 03:19:33 -0400
Received: by pvg12 with SMTP id 12so2372470pvg.19
        for <linux-ext4@vger.kernel.org>; Sat, 18 Jun 2011 00:19:33 -0700 (PDT)
In-Reply-To: <4DFB62C7.5070008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was thinking about this, and am wondering if it makes sense to have an absolute score for fragmentation instead of a relative one?

By absolute I mean something like fragments per MB or similar. A bad score might be anything > 1. For files smaller than 1 MB in size it would scale the ratio to the equivalent if the file was 1MB in size (e.g. a 16kB file with 4 fragments would have a score of 256, which is clearly bad).  Large files can have a score much less than 1, which is good. 

Cheers, Andreas

On 2011-06-17, at 8:20 AM, Eric Sandeen <sandeen@redhat.com> wrote:

> On 6/16/11 10:18 PM, Ted Ts'o wrote:
>> On Wed, Jun 15, 2011 at 03:33:19PM +0900, Kazuya Mio wrote:
>>> This patch adds get_fragment_score() to libe2p. get_fragment_score() returns
>>> the fragmentation score. It shows the percentage of extents whose size is
>>> smaller than the input argument "threshold".
>> 
>> It perhaps might be useful to also articulate what are the goals of
>> this metric.  Is just just to decide which files should be
>> defragmented, and which should be left alone?  Or do you want to be
>> able to compare which file is "worse off"?
>> 
>> I can imagine two files that have a score of 100%, but one is much
>> worse off than the other.  Does that matter?  It may or might not,
>> depending how you plan to use the fragmentation score, both now and in
>> the future.  So it might be good to explicitly declare what are the
>> goals for this metrics, and its planned use cases.
>> 
>> Regards,
> 
> Just as a random datapoint, the xfs_db "frag factor" has been a constant
> source of misunderstanding and woe for us.  (Granted, it works differently;
> it is an fs-wide number representing
> 
>    ((actual - ideal) / actual)
> 
> extents in the fs.)
> 
> This "% of fragments smaller than threshold" is more easily understandable
> and possibly more descriptive, but I think Ted makes good points;
> think about how this will be used, and whether the metric is useful.
> 
> It's hard to make a single number a) make sense to the user, and b)
> be usefully representative of fragmentation "badness" - so I am
> feeling very cautious about this idea overall.
> 
> To really convey fragmentation "badness" you'd almost want a histogram
> of fragment sizes, which is a bit hard to present concisely...
> 
> 
> -Eric
> 
>>                        - Ted
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
