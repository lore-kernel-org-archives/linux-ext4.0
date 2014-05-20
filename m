From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 20 May 2014 11:16:21 -0600
Message-ID: <537B8DE5.4040408@hp.com>
References: <1400185026-3972-1-git-send-email-jack@suse.cz> <1400185026-3972-3-git-send-email-jack@suse.cz> <537B1353.8060704@hp.com> <20140520135723.GB15177@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:1361 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaETRSZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2014 13:18:25 -0400
In-Reply-To: <20140520135723.GB15177@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/20/2014 07:57 AM, Theodore Ts'o wrote:
> Thavatchai, it would be really great if you could do lock_stat runs
> with both Jan's latest patches as well as yours.  We need to
> understand where the differences are coming from.
> 
> As I understand things, there are two differences between Jan and your
> approaches.  The first is that Jan is using the implicit locking of
> i_mutex to avoid needing to keep a hashed array of mutexes to
> synchronize an individual inode's being added or removed to the orphan
> list.
> 
> The second is that you've split the orphan mutex into an on-disk mutex
> and a in-memory spinlock.
> 
> Is it possible to split up your patch so we can measure the benefits
> of each of these two changes?  More interestingly, is there a way we
> can use the your second change in concert with Jan's changes?
> 
> Regards,
> 
> 						- Ted
> 

Ted, depending on what Jan does with my latest comment regarding the dirty optimization, her patch and my patch are functionally identical, with the exception that mine uses an explicit hashed lock to serialize add/delete within a single node.  Hers uses the fact that either i_mutex is already held or the node is not accessible to other thread.


My assumption is that with the hashed mutex, the contentions for the s_orphan_mutex will spread out more, increasing its chance to hit the mutex_lock fast path.  Anyway, I will do lock_stat to get more info.

Thanks,
Mak.

