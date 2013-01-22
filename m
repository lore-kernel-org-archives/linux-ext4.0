From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/12] ext4: Remove bogus wait for unwritten extents in
 ext4_ind_direct_IO
Date: Tue, 22 Jan 2013 14:44:00 +0100
Message-ID: <20130122134400.GB28331@quack.suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-4-git-send-email-jack@suse.cz>
 <87k3r5qxpf.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3AVNoD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 08:44:03 -0500
Content-Disposition: inline
In-Reply-To: <87k3r5qxpf.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 22-01-13 15:11:24, Dmitry Monakhov wrote:
> On Fri, 18 Jan 2013 13:00:37 +0100, Jan Kara <jack@suse.cz> wrote:
> > When using indirect blocks there is no possibility to have any unwritten
> > extents. So wait for them in ext4_ind_direct_IO() is just bogus.
> But as soon as i remember indirect implementation may also be used by
> extents based inodes 3074: ext4_ext_direct_IO
>     /* Use the old path for reads and writes beyond i_size. */
>     if (rw != WRITE || final_size > inode->i_size)
>        return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
> 
> Am I missing ?
  Ah, that's a catch. Thanks for pointing that out! So my patch is wrong
and that code path needs some cleaning and commenting. In particular I'm
afraid using dioread_nolock for inodes with indirect map causes data
exposure bugs when unlocked DIO read races with DIO write because such
inodes don't support uninitialized extents.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
