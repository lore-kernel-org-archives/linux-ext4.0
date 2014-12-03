From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/7 v4] ext4: Extent status tree shrinker improvements
Date: Wed, 3 Dec 2014 09:21:18 +0100
Message-ID: <20141203082118.GA8526@quack.suse.cz>
References: <1416927336-9328-1-git-send-email-jack@suse.cz>
 <20141203022018.GM13618@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbaLCIVT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2014 03:21:19 -0500
Content-Disposition: inline
In-Reply-To: <20141203022018.GM13618@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-12-14 21:20:18, Ted Tso wrote:
> I realized I hadn't ack'ed this patch series, but since this patch
> series is an improvement on what we have now, I've included them in
> the ext4 git tree.  I'm sure there's more improvements we can do on
> the shrinker, but we can use these patches as a starting point.
  Yeah, I'd like to return to this as well. In particular it should be
relatively straightforward to RCUify the list of inodes with extents to
shrink and thus avoid the relatively expensive s_es_lock in the shrinker.

Additionally we could batch removal from the list of inodes with
reclaimable extents (removal would happen only in the ext4_evict_inode()
and in the shrinker when it sees say 16 inodes with zero reclaimable
extents in the list - then it would grab the lock, scan part of the list
and remove all inodes with zero reclaimable extents). I'd expect that to
significantly reduce contention on s_es_lock.

But these need more measurements and experimentation...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
