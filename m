From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 03/12] ext4: Remove bogus wait for unwritten extents in
 ext4_ind_direct_IO
Date: Tue, 22 Jan 2013 22:22:21 +0800
Message-ID: <20130122142221.GA1763@gmail.com>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-4-git-send-email-jack@suse.cz>
 <87k3r5qxpf.fsf@openvz.org>
 <20130122134400.GB28331@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f54.google.com ([209.85.210.54]:56241 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3AVOI1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jan 2013 09:08:27 -0500
Received: by mail-da0-f54.google.com with SMTP id n2so3277911dad.41
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2013 06:08:26 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130122134400.GB28331@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 22, 2013 at 02:44:00PM +0100, Jan Kara wrote:
> On Tue 22-01-13 15:11:24, Dmitry Monakhov wrote:
> > On Fri, 18 Jan 2013 13:00:37 +0100, Jan Kara <jack@suse.cz> wrote:
> > > When using indirect blocks there is no possibility to have any unwritten
> > > extents. So wait for them in ext4_ind_direct_IO() is just bogus.
> > But as soon as i remember indirect implementation may also be used by
> > extents based inodes 3074: ext4_ext_direct_IO
> >     /* Use the old path for reads and writes beyond i_size. */
> >     if (rw != WRITE || final_size > inode->i_size)
> >        return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
> > 
> > Am I missing ?
>   Ah, that's a catch. Thanks for pointing that out! So my patch is wrong
> and that code path needs some cleaning and commenting. In particular I'm
> afraid using dioread_nolock for inodes with indirect map causes data
> exposure bugs when unlocked DIO read races with DIO write because such
> inodes don't support uninitialized extents.

Sorry, but I am still confused.  dioread_nolock is only for extent-based
file.  So when a file system without extent feature, dioread_nolock
couldn't be enabled.  It seems that we don't need to worry about
exposing stale data here.

Thanks,
                                                - Zheng
