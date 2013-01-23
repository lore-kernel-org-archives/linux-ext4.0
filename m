From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/12] ext4: Remove bogus wait for unwritten extents in
 ext4_ind_direct_IO
Date: Wed, 23 Jan 2013 10:42:48 +0100
Message-ID: <20130123094248.GA9821@quack.suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-4-git-send-email-jack@suse.cz>
 <87k3r5qxpf.fsf@openvz.org>
 <20130122134400.GB28331@quack.suse.cz>
 <20130122142221.GA1763@gmail.com>
 <20130122152243.GB32366@quack.suse.cz>
 <20130122160017.GA2072@gmail.com>
 <20130122231432.GA7244@quack.suse.cz>
 <20130123061141.GA10440@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab3AWJmu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2013 04:42:50 -0500
Content-Disposition: inline
In-Reply-To: <20130123061141.GA10440@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 23-01-13 14:11:41, Zheng Liu wrote:
> On Wed, Jan 23, 2013 at 12:14:32AM +0100, Jan Kara wrote:
> > On Wed 23-01-13 00:00:17, Zheng Liu wrote:
> > > On Tue, Jan 22, 2013 at 04:22:43PM +0100, Jan Kara wrote:
> > > > On Tue 22-01-13 22:22:21, Zheng Liu wrote:
> > > > > On Tue, Jan 22, 2013 at 02:44:00PM +0100, Jan Kara wrote:
> > > > > > On Tue 22-01-13 15:11:24, Dmitry Monakhov wrote:
> > > > > > > On Fri, 18 Jan 2013 13:00:37 +0100, Jan Kara <jack@suse.cz> wrote:
> > > > > > > > When using indirect blocks there is no possibility to have any unwritten
> > > > > > > > extents. So wait for them in ext4_ind_direct_IO() is just bogus.
> > > > > > > But as soon as i remember indirect implementation may also be used by
> > > > > > > extents based inodes 3074: ext4_ext_direct_IO
> > > > > > >     /* Use the old path for reads and writes beyond i_size. */
> > > > > > >     if (rw != WRITE || final_size > inode->i_size)
> > > > > > >        return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
> > > > > > > 
> > > > > > > Am I missing ?
> > > > > >   Ah, that's a catch. Thanks for pointing that out! So my patch is wrong
> > > > > > and that code path needs some cleaning and commenting. In particular I'm
> > > > > > afraid using dioread_nolock for inodes with indirect map causes data
> > > > > > exposure bugs when unlocked DIO read races with DIO write because such
> > > > > > inodes don't support uninitialized extents.
> > > > > 
> > > > > Sorry, but I am still confused.  dioread_nolock is only for extent-based
> > > > > file.  So when a file system without extent feature, dioread_nolock
> > > > > couldn't be enabled.  It seems that we don't need to worry about
> > > > > exposing stale data here.
> > > >   Well, you can have fs with extent feature enabled but still with inodes
> > > > using indirect map. But as Dmitry pointed out, ext4_should_dioread_nolock()
> > > > handles that correctly. So there's not a bug I was suspecting.
> > > 
> > > Yep, the patch itself is fine.  But that would be great if a comment is
> > > added here.
> >   No, the patch is wrong. The code before the patch is correct. We can get
> > to that code for extent based inode which has unwritten conversions pending
> > and we need to wait for those as otherwise we could return 0s in places
> > where we acknowledged successful write just a while ago. Or am I missing
> > something?
> 
> Ah, I see.  I guess that the problem is that the dio read races with buffered
> write.
> 
>    dio read                         buffered write
>                                     ->ext4_file_write
>                                       ->ext4_da_write_begin
>                                       ->ext4_da_write_end
>                                       [buffered write has finished, but the data
>                                        and metadata has not been flushed]
>    ->generic_file_aio_read
>      ->filemap_write_and_wait_range
>        ->do_writepages
>          ->ext4_da_writepages
>      ->filemap_fdatawait_range
>        ->wait_on_page_writeback
>                                     ->ext4_end_bio
>                                       ->end_page_writeback
>                                         [unwritten extent has not been
>                                          converted]
>      ->ext4_ind_direct_IO
>        [here we need to flush unwritten io]
  Yes, exactly.

> So it seems that this patch could be applied after reworking unwritten extent
> conversion.
  Yes. When PageWriteback is cleared after extent conversion, this waiting
can go away and everything should be fine.

> FWIW, after applied this patch, the latency of dio read could be reduced
> dramatically.  So that would be great if this patch can be applied when it
> doesn't break something.
  Sure, I'll have that in mind.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
