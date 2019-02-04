Return-Path: <SRS0=rNbD=QL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1BADC282C4
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Feb 2019 09:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F4A22147A
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Feb 2019 09:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfBDJpW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Feb 2019 04:45:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:42528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbfBDJpW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 4 Feb 2019 04:45:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6BE0AC98;
        Mon,  4 Feb 2019 09:45:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id A745D1E157D; Mon,  4 Feb 2019 10:45:20 +0100 (CET)
Date:   Mon, 4 Feb 2019 10:45:20 +0100
From:   Jan Kara <jack@suse.cz>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] Revert "ext4: use ext4_write_inode() when fsyncing w/o a
 journal"
Message-ID: <20190204094520.GA20085@quack2.suse.cz>
References: <20190201044219.12802-1-tytso@mit.edu>
 <20190201212119.GB11643@quack2.suse.cz>
 <20190202040811.GB9802@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190202040811.GB9802@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 01-02-19 23:08:11, Theodore Y. Ts'o wrote:
> On Fri, Feb 01, 2019 at 10:21:20PM +0100, Jan Kara wrote:
> > On Thu 31-01-19 23:42:19, Theodore Ts'o wrote:
> > > This reverts commit ad211f3e94b314a910d4af03178a0b52a7d1ee0a.
> > > 
> > > As Jan Kara pointed out, this change was unsafe since it means we lose
> > > the call to sync_mapping_buffers() in the nojournal case.  The
> > > original point of the commit was avoid taking the inode mutex (since
> > > it causes a lockdep warning in generic/113); but we need the mutex in
> > > order to call sync_mapping_buffers().
> > 
> > Actually, I don't think sync_mapping_buffers() needs inode mutex (i_rwsem
> > these days). It uses blkdev_mapping->private_lock for synchronization of
> > operations on the list of buffers and fsync_buffers_list() seems to be
> > pretty careful about races with mark_buffer_dirty_inode(). So why do you
> > think we need i_rwsem?
> 
> Hmm, I think you're right.  I wonder if we can therefore remove the
> inode_lock() in __generic_file_fsync() then...   What do you think?

That's actually a good question. I was thinking about why we have
inode_lock() in __generic_file_fsync().  The only reason I could come up
with is that when fsync(2) races with write(2) or truncate(2), with
inode_lock() in __generic_file_fsync() you will either get old or new
metadata state on disk. Without inode_lock() you could get some
intermediate metadata state and thus after a crash may not be able to see
even the old data. We are here on the thin ice of how good data consistency
do we provide after a crash for non-journalling filesystems. It is never
going to be perfect but this change would seem like a noticeable regression
to me. What do you think?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
