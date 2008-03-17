From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: Reversing order of transaction start and page_lock for ext3/4
Date: Mon, 17 Mar 2008 08:22:17 -0800
Message-ID: <1205770937.26074.6.camel@dyn9047017100.beaverton.ibm.com>
References: <20080313180519.GL12523@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:60863 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYCQPWB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 11:22:01 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2HFM1EV029388
	for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2008 11:22:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2HFM1vd190666
	for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2008 09:22:01 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2HFM1Zj023146
	for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2008 09:22:01 -0600
In-Reply-To: <20080313180519.GL12523@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-03-13 at 19:05 +0100, Jan Kara wrote:
>   Hi,
> 
>   As Mark Fasheh pointed out, we cannot take page_lock inside a transaction
> commit because that could possibly deadlock with other thread holding the
> page_lock and waiting for commit to finish in journal_start. This is
> kind-of blocker for my new approach of handling of ordered mode in JBD.
> 
> So first, I'd like to ask what other people think about reversing locking
> order of page_lock and transaction start in ext3/4? I personally find it a
> good thing anyway (I've stumbled on problems with the current locking order
> several times, but so far I could always workaround them), logically it
> simply "makes sence" as transaction handle is naturally more long-lived
> than a lock on one page.
> 
> For the case that we agree we want to reverse the order, I've looked into
> how hard would it be. Ordinary write path is trivial. If we provide
> page_mkwrite function (which should be quite simple), we don't have to be
> afraid of instantiating holes in writepage so that makes things in
> writepage simpler (although we'd pay the some performance for writing page
> of zeros into the hole and later writing real data in writepage - currently
> we do only the second write together with block allocation). With
> page_mkwrite, we don't have to start transaction at all in writepage in
> writeback and ordered modes.

3 years ago, I tried to support writepages() for ext3 and ran into this.
At that time, page_mkwrite() was still under works and couldn't use it.
I think with page_mkwrite() we can do this, except that its a slight
behaviour change in the sense that the app could get allocation errors
(ENOSPC) while writing to mmap(). But I think its a good thing.

For ext4 delayed allocation, we might see small performance issue - but
I think it would be a special case.

Thanks,
Badari

