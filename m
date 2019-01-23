Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7BCC282C0
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 12:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6CB721019
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 12:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfAWMfy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 07:35:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:40474 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbfAWMfy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Jan 2019 07:35:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E95AADE4;
        Wed, 23 Jan 2019 12:35:52 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E90211E3FF5; Wed, 23 Jan 2019 13:35:51 +0100 (CET)
Date:   Wed, 23 Jan 2019 13:35:51 +0100
From:   Jan Kara <jack@suse.cz>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-ext4@vger.kernel.org, harshads@google.com
Subject: Re: [PATCH] ext4: don't submit unwritten extent while holding active
 jbd2 handle
Message-ID: <20190123123551.GD20927@quack2.suse.cz>
References: <20181225141625.18141-1-xiaoguang.wang@linux.alibaba.com>
 <20190103031840.GB6908@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190103031840.GB6908@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 02-01-19 22:18:40, Theodore Y. Ts'o wrote:
> On Tue, Dec 25, 2018 at 10:16:25PM +0800, Xiaoguang Wang wrote:
> > In ext4_writepages(), for every iteration, mpage_prepare_extent_to_map()
> > will try to find 2048 pages to map and normally one bio can contain 256
> > pages at most. If we really found 2048 pages to map, there will be 4 bios
> > and 4 ext4_io_submit() calls which are called both in ext4_writepages()
> > and mpage_map_and_submit_extent().
> > 
> > But note that in mpage_map_and_submit_extent(), we hold a valid jbd2 handle,
> > when dioread_nolock is enabled and extent is unwritten, jbd2 commit thread
> > will wait this handle to finish, so wait the unwritten extent is written to
> > disk, this will introduce unnecessary stall time, especially longer when the
> > writeback operation is io throttled, need to fix this issue.
> > 
> > Here for this scene, we accumulate bios in ext4_io_submit's io_bio, and only
> > submit these bios after dropping the jbd2 handle.
> 
> I think it would be better if we simply don't even try to *start* the
> jbd2 handle at all until we after ext4_end_io_rsv_work() is called.  I
> suspect the best place to do this will be in ext4_end_io().  The
> shorter time we hold the handle, the better the commit completion
> latency will be.  (After all, while we are assembling the bios, memory
> allocations could block if the system is under heavy memory pressure,
> etc.)

Currently this will create a deadlock possibility. Transaction commit can
wait for page writeback (data=ordered requirements) and thus
ext4_journal_start() can end up blocking waiting for transaction commit
which waits for page writeback => you cannot start new transaction while
you have a page locked or under writeback.

But there are in fact two handles ext4_writepages() creates. One is the
reserved one, which we use for extent conversion on io_end - that one
actually does not hold off transaction commit. The reserved space just gets
automatically "reallocated" in the newly started transaction. And then
there's the normal handle which is used for allocating blocks / splitting
extents during ext4_writepages(). That does hold-off transaction commit and
I think this was the handle Xiaoguang was complaining about. Now I also
don't like what Xiaoguang has implemented either because that's just going
to cause another set of problems - essentially it just duplicates current
bio plugging mechanism however without all the precautions that one takes
to avoid deadlocks.

> This will also make it a bit easier to support dioread_nolock for
> block sizes < page size, since we need to start a separate handle for
> each extent that needs to be converted, and if the block size is 4k
> and the page size is 64k (for example, on the PowerPC), there might be
> as many as 16 extents that have to be modified for a heavily
> fragmented file system.

Starting handle for each extent is currently problematic because of
ordering constrains I have described. You need to lock the page for
writeback but once you have the page locked, you cannot start new
transaction. So you have to have transaction ready for being able to write
the whole page before locking the page.

> Supporting dioread_nolock for 1k file systems on x86 and 4k file
> systems on ppc64/ppc64le will allow us to make dioread_nolock the only
> supported write path, dropping the current default.  This will give us
> only one write path to optimize, debug, and maintain, which will be a
> Good Thing.

Agreed on this but I think we need to approach this from different angle
:). Lot of these problems would go away if we got rid of data=ordered pages
as that completely removes the page lock / page writeback vs transaction
handle start lock dependency. So how about just create
ext4_writepages_unwritten() temporarily that will be used for
dioread_nolock mode as a copy-paste of ext4_writepages() (possibly into a
separate file since the writepages code is big anyway). Then we can
simplify the new version with the knowledge that we are using
dioread_nolock and thus don't have ordered pages and can start transactions
under page lock (which also deals with the problem that has started this
thread). Then the result will be hopefully simple enough that we can add
support for blocksize < pagesize to it. Also I'd be really happy if we
managed to implement writeout beyond EOF without creating unwritten extents
first as that will get appending to dioread_nolock file the same
performance as without it. And then we can just drop to old writeback code
and switch to dioread_nolock unconditionally.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
