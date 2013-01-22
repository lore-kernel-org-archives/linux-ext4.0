From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 03/12] ext4: Remove bogus wait for unwritten extents in ext4_ind_direct_IO
Date: Tue, 22 Jan 2013 18:12:38 +0400
Message-ID: <87ehhdqpbd.fsf@openvz.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz> <1358510446-19174-4-git-send-email-jack@suse.cz> <87k3r5qxpf.fsf@openvz.org> <20130122134400.GB28331@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:50269 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3AVOMn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jan 2013 09:12:43 -0500
Received: by mail-lb0-f181.google.com with SMTP id gm6so1309669lbb.40
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2013 06:12:41 -0800 (PST)
In-Reply-To: <20130122134400.GB28331@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 22 Jan 2013 14:44:00 +0100, Jan Kara <jack@suse.cz> wrote:
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
Yes that's why dioread_nolock works only for extent based inodes

static inline int ext4_should_dioread_nolock(struct inode *inode)
{
        if (!test_opt(inode->i_sb, DIOREAD_NOLOCK))
                return 0;
        if (!S_ISREG(inode->i_mode))
                return 0;
                if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
                   return 0;
                   if (ext4_should_journal_data(inode))
                return 0;
        return 1;
}

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
