From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
Date: Mon, 5 May 2008 19:06:36 +0200
Message-ID: <20080505170636.GK25722@duck.suse.cz>
References: <20080306174209.GA14193@duck.suse.cz> <1209166706.6040.20.camel@localhost.localdomain> <20080428122626.GC17054@duck.suse.cz> <1209402694.23575.5.camel@badari-desktop> <20080428180932.GI17054@duck.suse.cz> <1209409764.11872.6.camel@localhost.localdomain> <20080429124321.GD1987@duck.suse.cz> <1209654981.27240.19.camel@badari-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34070 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753183AbYEERGi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2008 13:06:38 -0400
Content-Disposition: inline
In-Reply-To: <1209654981.27240.19.camel@badari-desktop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 01-05-08 08:16:21, Badari Pulavarty wrote:
> Hi Andrew & Jan,
> 
> I was able to reproduce the customer problem involving DIO
> (invalidate_inode_pages2) problem by writing simple testcase
> to keep writing to a file using buffered writes and DIO writes
> forever in a loop. I see DIO writes fail with -EIO.
> 
> After a long debug, found 2 cases how this could happen.
> These are race conditions with journal_try_to_free_buffers()
> and journal_commit_transaction().
> 
> 1) journal_submit_data_buffers() tries to get bh_state lock. If
> try lock fails, it drops the j_list_lock and sleeps for
> bh_state lock, while holding a reference on the buffer.
> In the meanwhile, journal_try_to_free_buffers() can clean up the
> journal head could call try_to_free_buffers(). try_to_free_buffers()
> would fail due to the reference held by journal_submit_data_buffers()
> - which in turn causes failues for DIO (invalidate_inode_pages2()).
> 
> 2) When the buffer is on t_locked_list waiting for IO to finish,
> we hold a reference and give up the cpu, if we can't get
> bh_state lock. This causes try_to_free_buffers() to fail.
> 
> Fix is to drop the reference on the buffer if we can't get
> bh_state lock, give up the cpu and re-try the whole operation -
> instead of waiting for the vh_state lock.
> 
> Does this look like a resonable fix ?
  As Mingming pointed out there are few other places where we could hold
the bh reference. Note also that we accumulate references to buffers in the
wbuf[] list and we need that for submit_bh() which consumes one bh
reference. Generally, it seems to me as a too fragile and impractical
rule "nobody can hold bh reference when not holding page lock" which is
basically what it comes down to if you really want to be sure that
journal_try_to_free_buffers() succeeds. And also note that in principle
there are other places which hold references to buffers without holding the
page lock - for example writepage() in ordered mode (although this one is
in practice hardly triggerable). So how we could fix at least the races
with commit code is to implement launder_page() callback for ext3/4 which
would wait for the previous transaction commit in case the page has buffers
that are part of that commit (I don't want this logic in
journal_try_to_free_buffers() as that is called also on memory-reclaim
path, but journal_launder_page() is fine with me). This would be correct
but could considerably slow down O_DIRECT writes in cases they're mixed
with buffered writes so I'm not sure if this is acceptable.
  OTOH with the ordered mode rewrite patch, the problem with commit code
also goes away since there we don't need extra references to data buffers
(we use just filemap_fdatawrite).

> 1) journal_submit_data_buffers() tries to get bh_state lock. If
> try lock fails, it drops the j_list_lock and sleeps for
> bh_state lock, while holding a reference on the buffer head.
> In the meanwhile, journal_try_to_free_buffers() can clean up the
> journal head could call try_to_free_buffers(). try_to_free_buffers()
> would fail due to the reference held by journal_submit_data_buffers()
> - which inturn causes failues for DIO (invalidate_inode_pages2()).
> 
> 2) When the buffer is on t_locked_list waiting for IO to finish,
> we hold a reference and give up the cpu, if we can't get 
> bh_state lock. This causes try_to_free_buffers() to fail.
> 
> Fix is to drop the reference on the buffer, give up the cpu
> and re-try the whole operation.
> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> Reviewed-by: Mingming Cao <mcao@us.ibm.com>

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
