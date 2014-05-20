From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 20 May 2014 09:57:23 -0400
Message-ID: <20140520135723.GB15177@thunk.org>
References: <1400185026-3972-1-git-send-email-jack@suse.cz>
 <1400185026-3972-3-git-send-email-jack@suse.cz>
 <537B1353.8060704@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51364 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbaETN5d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2014 09:57:33 -0400
Content-Disposition: inline
In-Reply-To: <537B1353.8060704@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 20, 2014 at 02:33:23AM -0600, Thavatchai Makphaibulchoke wrote:
> Please see my one comment below.
> 
> BTW, I've run aim7 on your before I notice what I commented below.  There are workloads that my patch outperform yours and vice versa.  I will have to redo it over again.

Thavatchai, it would be really great if you could do lock_stat runs
with both Jan's latest patches as well as yours.  We need to
understand where the differences are coming from.

As I understand things, there are two differences between Jan and your
approaches.  The first is that Jan is using the implicit locking of
i_mutex to avoid needing to keep a hashed array of mutexes to
synchronize an individual inode's being added or removed to the orphan
list.

The second is that you've split the orphan mutex into an on-disk mutex
and a in-memory spinlock.

Is it possible to split up your patch so we can measure the benefits
of each of these two changes?  More interestingly, is there a way we
can use the your second change in concert with Jan's changes?

Regards,

						- Ted
