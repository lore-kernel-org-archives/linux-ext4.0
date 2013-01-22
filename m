From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/12] ext4: Remove bogus wait for unwritten extents in
 ext4_ind_direct_IO
Date: Tue, 22 Jan 2013 16:22:43 +0100
Message-ID: <20130122152243.GB32366@quack.suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-4-git-send-email-jack@suse.cz>
 <87k3r5qxpf.fsf@openvz.org>
 <20130122134400.GB28331@quack.suse.cz>
 <20130122142221.GA1763@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab3AVPWq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 10:22:46 -0500
Content-Disposition: inline
In-Reply-To: <20130122142221.GA1763@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 22-01-13 22:22:21, Zheng Liu wrote:
> On Tue, Jan 22, 2013 at 02:44:00PM +0100, Jan Kara wrote:
> > On Tue 22-01-13 15:11:24, Dmitry Monakhov wrote:
> > > On Fri, 18 Jan 2013 13:00:37 +0100, Jan Kara <jack@suse.cz> wrote:
> > > > When using indirect blocks there is no possibility to have any unwritten
> > > > extents. So wait for them in ext4_ind_direct_IO() is just bogus.
> > > But as soon as i remember indirect implementation may also be used by
> > > extents based inodes 3074: ext4_ext_direct_IO
> > >     /* Use the old path for reads and writes beyond i_size. */
> > >     if (rw != WRITE || final_size > inode->i_size)
> > >        return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
> > > 
> > > Am I missing ?
> >   Ah, that's a catch. Thanks for pointing that out! So my patch is wrong
> > and that code path needs some cleaning and commenting. In particular I'm
> > afraid using dioread_nolock for inodes with indirect map causes data
> > exposure bugs when unlocked DIO read races with DIO write because such
> > inodes don't support uninitialized extents.
> 
> Sorry, but I am still confused.  dioread_nolock is only for extent-based
> file.  So when a file system without extent feature, dioread_nolock
> couldn't be enabled.  It seems that we don't need to worry about
> exposing stale data here.
  Well, you can have fs with extent feature enabled but still with inodes
using indirect map. But as Dmitry pointed out, ext4_should_dioread_nolock()
handles that correctly. So there's not a bug I was suspecting.

							Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
