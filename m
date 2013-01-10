From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] call end_page_writeback after converting unwritten
 extents in ext4_end_io
Date: Thu, 10 Jan 2013 15:47:19 +0100
Message-ID: <20130110144719.GA26413@quack.suse.cz>
References: <20130110055617.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab3AJOrV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jan 2013 09:47:21 -0500
Content-Disposition: inline
In-Reply-To: <20130110055617.GA4415@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 10-01-13 13:56:17, Zheng Liu wrote:
> Now I am trying to handle AIO DIO with O_SYNC using extent status tree in ext4.
> After applied Christoph's patch series, O_SYNC semantics in ext4 will be broken.
> This problem can be fixed using extent status tree.  But we will get a deadlock
> because i_mutex needs to be taken in ext4_sync_file() and then it will wait on
> i_unwritten==0.  So let's consider what happends after applied Christoph's
> patches and using extent status tree to ensure AIO DIO with O_SYNC semantics.
> 
>   ext4_ext_direct_IO:              ext4_ind_direct_IO:
>                                    ->ext4_file_write()
>                                      ->mutex_lock(i_mutex)
>                                        ->ext4_ind_direct_IO()
>                                          [if this is an append dio]
>                                      ->mutex_unlock(i_mutex)
>   ->ext4_file_write()
>     ->mutex_lock(i_mutex)
>     ->ext4_ext_direct_IO()
>     ->mutex_unlock(i_mutex)
>                                      ->generic_write_sync()
>                                        ->ext4_sync_file()
>                                          ->mutex_lock(i_mutex)
>                                          ->ext4_flush_unwritten_io()
>                                            ->ext4_do_flush_complete_IO()
>                                              [there is empty list]
>                                            ->ext4_unwritten_wait()
>                                              [wait on i_unwritten==0 because
>                                               in ext4_ext_direct_IO i_unwritten
>                                               has been increased]
>   kworkd:
>   ->dio_complete()
>     ->ext4_end_dio()
>       ->ext4_es_convert_unwritten_extents()
>         [convert unwritten extents in status
>          tree to ensure O_SYNC semantics]
>       ->ext4_add_complete_io()
>     ->generic_write_sync()
>       ->ext4_sync_file()
>         ->mutex_lock(i_mutex)
>           [*DEADLOCK*]
> 
> Thus all we need to do is do not wait on i_unwritten==0.  But, as this
> commit (c278531d) described, there is a time window that integrity is
> broken.  So we need to call end_page_writeback() after converting
> unwritten extents in ext4_end_io().  However, if we call end_page_writeback()
> after conversion has been done in ext4_end_io(), we will get another deadlock
> because in ext4_convert_unwritten_extents() we need to start a journal and it is
> possible to cause a journal commit.  At the time if ext4_write_begin() is
> called, it also will start a journal and then it will wait on writeback in
> grab_cache_page_write_begin().
  Exactly.

> Now I have an idea to solve this problem.  We start a journal before submitting
> an io request rather than start it in ext4_convert_unwritten_extents().  The
> reason of starting a journal in ext4_convert_unwritten_extents() is that we need
> to calculate credits for journal.  But as far as I understand the credits is not
> increased in this function because we have splitted extents before submitting
> this io request.  A 'handle_t *handle' will be added into ext4_io_end_t, and it
> will be used in ext4_convert_unwritten_extents().  Then we can avoid to
> trigger a journal commit when starting a journal.
  I'm actually already working on a solution. The disadvantage of starting
a transaction before IO submission is that the handle will hold transaction
open all the time until IO is finished and extent converted. So it can
effectively block any filesystem activity for a relatively long time. I've
already written a patch for JBD2 to allow transaction reservation - it
reserves blocks in the journal but they are not attached to a particular
transaction. Later during extent conversion we transform this reservation
into a real handle (without waiting for the journal so locking is OK).

The part I'm missing so far is adding transaction reservation into IO
submission path. That is actually somewhat tricky because we have to do it
before taking page locks and propagate the reserved handle all the way down
to the point where we allocate io_end. And furthermore we have to somehow
deal with the fact that IO to one extent can be split among multiple BIOs
(as it happens e.g. when an extent is longer than 512 KB which is usual
limit on BIO size) and thus multiple io_end structures are created and
extent is converted in parts (actually we didn't think about this problem
previously in extent conversion code).  We don't know in advance how much
BIOs we'll need to write the extents (bio_add_page() decides when the BIO
is full and there are other constraints on BIO than just the total size) so
what we need to do it so have one io_end structure shared by all the BIOs
covering the extent. That will also save us from unnecessary splitting and
joining of extents for conversion. But doing that requires some changes to
io submission path which is why it's taking me longer than I'd like (plus I
have other obligations than just improving ext4 ;) But I'm working on it so
please stay tuned...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
