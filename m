From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: async commit & write barrier code
Date: Tue, 23 Sep 2008 15:41:02 -0500
Message-ID: <48D9545E.8040302@redhat.com>
References: <48D7D3DF.70505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49517 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbYIWUlH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2008 16:41:07 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m8NKf4IN003610
	for <linux-ext4@vger.kernel.org>; Tue, 23 Sep 2008 16:41:04 -0400
In-Reply-To: <48D7D3DF.70505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler wrote:
> After today's call, I was poking around a bit to try and understand 
> better how the async commit code plays with the write barrier.
> 
> journal_submit_commit_record seems to disable the barriers when async IO 
> is enabled if I read the code correctly. If this is true, how can we 
> provide any promises of on disk data integrity after an fsync()?
> 
> Regards,
> 
> Ric

I agree; with async commit, ext4/jbd2 is running with *no* barrier
writes in jbd code. (FWIW, on the fsync front, fsync calls
blkdev_issue_flush in ext4 so that part may actually be ok in the end).

But at a minimum, I think that for data=ordered, there is now *no*
guarantee that the associated file data actually hits disk before the
size updates, is there?

-Eric
