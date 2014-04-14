From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] fs/ext4: increase parallelism in updating ext4 orphan
 list
Date: Mon, 14 Apr 2014 19:40:24 +0200
Message-ID: <20140414174024.GC13860@quack.suse.cz>
References: <1380728283-61038-1-git-send-email-tmac@hp.com>
 <1396456148-20455-1-git-send-email-tmac@hp.com>
 <20140402174109.GD8657@quack.suse.cz>
 <534C135A.9010803@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, T Makphaibulchoke <tmac@hp.com>,
	tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	aswin@hp.com
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <534C135A.9010803@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 14-04-14 10:56:58, Thavatchai Makphaibulchoke wrote:
> On 04/02/2014 11:41 AM, Jan Kara wrote:
> >   Thanks for the patches and measurements! So I agree we contend a lot on
> > orphan list changes in ext4. But what you do seems to be unnecessarily
> > complicated and somewhat hiding the real substance of the patch. If I
> > understand your patch correctly, all it does is that it does the
> > preliminary work (ext4_reserve_inode_write(),
> > ext4_journal_get_write_access()) without the global orphan mutex (under the
> > hashed mutex).
> > 
> > However orphan operations on a single inode are already serialized by
> > i_mutex so there's no need to introduce any new hashed lock. Just add
> > assertion mutex_locked(&inode->i_mutex) to ext4_orphan_add() and
> > ext4_orphan_del() - you might need to lock i_mutex around the code in
> > fs/ext4/migrate.c and in ext4_tmpfile() but that should be fine.
> > 
> 
> I've done some data collection.  Looks like there are more callers to
> ext4_orphan_add() and ext4_orphan_del() without holding the i_mutex as
> expected.
> 
> This is what I've found on one of my 8 core machine.
> 
>                  --------------------------------------------
>                  |   ext4_orphan_add  |   ext4_orphan_del   |
>                  --------------------------------------------
>                  |   Total  | without |   Total  | without  |
>                  |          | holding |          | holding  |
>                  |          | i_mutex |          | i_mutex  |
> -------------------------------------------------------------
> | First comes up |          |         |          |          | 
> | to multi-user  |     2446 |     363 |     2081 |     1659 |
> -------------------------------------------------------------
> | After alltests | 23812582 |  173599 | 23853863 |  2467999 |
> -------------------------------------------------------------
> | After disk     | 30860981 |  818255 | 30261069 |  8881905 |
> -------------------------------------------------------------
> 
> Though some orphan calls already held the i_mutex, using the i_mutex to
> serialize orphan operations within a single inode seems to negate all of
> the performance improvement from the original patch.  There seems to be
> no performance differences form the current implementation.
  Thanks for trying that out! Can you please send me a patch you have been
testing? Because it doesn't quite make sense to me why using i_mutex should
be worse than using hashed locks...

> > Also I'm somewhat failing to see what the spinlock s_orphan_lock brings us.
> > I'd guess that the mutex could still protect also the in-memory list and we
> > have to grab it in all the relevant cases anyway (in some rare cases we
> > could avoid taking the mutex and spinlock would be enough but these
> > shouldn't be performance relevant). Please correct me if I'm wrong here, I
> > didn't look at the code for that long.
> > 
> 
> The same data also shows 0 call from the error part.  Re-running the
> benchmark, replacing the spinlock with the same disk oprhan mutex, does
> not seem to have any performance impact from that of the original patch.
  OK, at least that makes sense.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
