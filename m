From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4 v2] ext4: Fix data exposure after a crash
Date: Wed, 13 Apr 2016 15:32:09 +0200
Message-ID: <20160413133209.GB23550@quack2.suse.cz>
References: <1459354767-8693-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Weller.Huang@cn.bosch.com,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958AbcDMNcN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Apr 2016 09:32:13 -0400
Content-Disposition: inline
In-Reply-To: <1459354767-8693-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello!

On Wed 30-03-16 18:19:23, Jan Kara wrote:
> this is a second version of the patches to fix data exposure after a crash
> in data=ordered mode. Since previous revision I have implemented suggestion
> by Ted that it is enough to wait for outstanding writeback from jbd2 thread
> when IO was already submitted during delalloc writeback (see patches 3 and
> 4 for details).
> 
> I have checked that indeed jbd2 did not submit any data buffers under
> appropriate load (I've used randwrite workload from fio) with the improvement
> but I didn't observe any measurable improvement in transaction commit times
> - waiting for already outstanding writeback was dominating the commit time and
> the additional buffers jbd2 was originally submitting apparently didn't make
> a big difference. At least for this workload. I have a hard time coming up with
> some other workload where the optimization would make a big difference since 
> flusher thread ends up submitting overwritten blocks anyway which makes jbd2
> thread wait for the IO. But still conceptually the change makes sense so it
> may be worth it. So Ted, feel free to either merge or drop the last two
> patches in this series...

Ping Ted? It would be good to merge at least the first patch in the series
during this cycle... Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
