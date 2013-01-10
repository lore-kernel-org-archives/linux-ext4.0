From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC] call end_page_writeback after converting unwritten extents in
 ext4_end_io
Date: Thu, 10 Jan 2013 13:56:17 +0800
Message-ID: <20130110055617.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59942 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3AJFme (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jan 2013 00:42:34 -0500
Received: by mail-pa0-f45.google.com with SMTP id bg2so158602pad.18
        for <linux-ext4@vger.kernel.org>; Wed, 09 Jan 2013 21:42:33 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Now I am trying to handle AIO DIO with O_SYNC using extent status tree in ext4.
After applied Christoph's patch series, O_SYNC semantics in ext4 will be broken.
This problem can be fixed using extent status tree.  But we will get a deadlock
because i_mutex needs to be taken in ext4_sync_file() and then it will wait on
i_unwritten==0.  So let's consider what happends after applied Christoph's
patches and using extent status tree to ensure AIO DIO with O_SYNC semantics.

  ext4_ext_direct_IO:              ext4_ind_direct_IO:
                                   ->ext4_file_write()
                                     ->mutex_lock(i_mutex)
                                       ->ext4_ind_direct_IO()
                                         [if this is an append dio]
                                     ->mutex_unlock(i_mutex)
  ->ext4_file_write()
    ->mutex_lock(i_mutex)
    ->ext4_ext_direct_IO()
    ->mutex_unlock(i_mutex)
                                     ->generic_write_sync()
                                       ->ext4_sync_file()
                                         ->mutex_lock(i_mutex)
                                         ->ext4_flush_unwritten_io()
                                           ->ext4_do_flush_complete_IO()
                                             [there is empty list]
                                           ->ext4_unwritten_wait()
                                             [wait on i_unwritten==0 because
                                              in ext4_ext_direct_IO i_unwritten
                                              has been increased]
  kworkd:
  ->dio_complete()
    ->ext4_end_dio()
      ->ext4_es_convert_unwritten_extents()
        [convert unwritten extents in status
         tree to ensure O_SYNC semantics]
      ->ext4_add_complete_io()
    ->generic_write_sync()
      ->ext4_sync_file()
        ->mutex_lock(i_mutex)
          [*DEADLOCK*]

Thus all we need to do is do not wait on i_unwritten==0.  But, as this
commit (c278531d) described, there is a time window that integrity is
broken.  So we need to call end_page_writeback() after converting
unwritten extents in ext4_end_io().  However, if we call end_page_writeback()
after conversion has been done in ext4_end_io(), we will get another deadlock
because in ext4_convert_unwritten_extents() we need to start a journal and it is
possible to cause a journal commit.  At the time if ext4_write_begin() is
called, it also will start a journal and then it will wait on writeback in
grab_cache_page_write_begin().

Now I have an idea to solve this problem.  We start a journal before submitting
an io request rather than start it in ext4_convert_unwritten_extents().  The
reason of starting a journal in ext4_convert_unwritten_extents() is that we need
to calculate credits for journal.  But as far as I understand the credits is not
increased in this function because we have splitted extents before submitting
this io request.  A 'handle_t *handle' will be added into ext4_io_end_t, and it
will be used in ext4_convert_unwritten_extents().  Then we can avoid to
trigger a journal commit when starting a journal.

Hope my description is clear.  Any comments or feedbacks are always welcome.


Jan, I don't know whether you have begun to try to fix this problem or not.  If
there has an update, please let me know.

Thanks,
						- Zheng
