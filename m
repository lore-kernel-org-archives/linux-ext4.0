From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2] ext4: move ext4_update_i_disksize() into
 mpage_map_and_submit_extent()
Date: Tue, 15 Apr 2014 22:18:25 +0200
Message-ID: <20140415201825.GC13276@quack.suse.cz>
References: <1397226957-9581-1-git-send-email-tytso@mit.edu>
 <1397310327-18147-1-git-send-email-tytso@mit.edu>
 <20140415162627.GA10144@quack.suse.cz>
 <20140415192642.GE4456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	pfonseca@mpi-sws.org, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140415192642.GE4456@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 15-04-14 15:26:42, Ted Tso wrote:
> On Tue, Apr 15, 2014 at 06:26:27PM +0200, Jan Kara wrote:
> > On Sat 12-04-14 09:45:27, Ted Tso wrote:
> > > The function ext4_update_i_disksize() is used in only one place, in
> > > the function mpage_map_and_submit_extent().  Move there to simplify
> > > the code paths, and also move the call to ext4_mark_inode_dirty() into
> > > the i_data_sem's critical region, to be consistent with all of the
> > > other places where we update i_disksize.  That way, we also keep the
> > > raw_inode's i_disksize protected.
> > > 
> > > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > > Cc: stable@vger.kernel.org
> >   I agree that it makes sense to have all the places consistent and protect
> > raw disk inode i_disksize with i_data_sem. OTOH I don't see a way how this
> > can cause any real harm (but I guess you expect there might be something as
> > you CCed stable), so can you explain it please?
> 
> This was the case I was worried about:
> 
>         CPU #1                                 CPU #2
> 
> 1.      down_write(&i_data_sem)
> 2.      Modify i_disk_size
> 4.      up_write(&i_data_sem)
> 5.                                           down_write(&i_data_sem)
> 6.                                           Modify i_disk_size
> 7.                                           Copy i_disk_size to on-disk inode
> 8.                                           up_write(&i_data_sem)
> 9.      Copy i_disk_size to on-disk inode
> 
> 
> It's the standard data race; it might not be a problem on Intel CPU's,
> but in general, cpu #1 might still have a stale copy of i_disk_size in
> its cache, and hence it might copying the old, outdated value into the
> on-disk inode.
  Yes, that could be a problem even on Intel CPU - not because of cache
coherency but because old i_disk_size value might be speculatively
preloaded before CPU#2 updates its value. So feel free to add:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
