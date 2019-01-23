Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB4AC282C0
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 12:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35A1F20870
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 12:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfAWMsY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 07:48:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:42890 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbfAWMsY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Jan 2019 07:48:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93F13AB7D;
        Wed, 23 Jan 2019 12:48:23 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 45F991E3FF5; Wed, 23 Jan 2019 13:48:23 +0100 (CET)
Date:   Wed, 23 Jan 2019 13:48:23 +0100
From:   Jan Kara <jack@suse.cz>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-ext4@vger.kernel.org, Liu Bo <bo.liu@linux.alibaba.com>
Subject: Re: [PATCH v2 2/2] ext4: fix slow writeback under dioread_nolock and
 nodelalloc
Message-ID: <20190123124823.GE20927@quack2.suse.cz>
References: <20181215054840.5960-1-xiaoguang.wang@linux.alibaba.com>
 <20181215054840.5960-2-xiaoguang.wang@linux.alibaba.com>
 <20190123062737.GC7597@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123062737.GC7597@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 23-01-19 01:27:38, Theodore Y. Ts'o wrote:
> On Sat, Dec 15, 2018 at 01:48:40PM +0800, Xiaoguang Wang wrote:
> > With "nodelalloc", blocks are allocated at the time of writing, and with
> > "dioread_nolock", these allocated blocks are marked as unwritten as well,
> > so bh(s) attached to the blocks have BH_Unwritten and BH_Mapped.
> 
> I've been looking at your patches, and it seems that a simpler way,
> perhaps more maintainable approach in the long term is to change how
> we write to newly allocated blocks.  Today, we have two ways of doing
> this:
> 
> 1) In the dioread_nolock case, we allocate blocks, insert an entry in
> the extent tree with the blocks marked uninitialized, write the
> blocks, and then mark the blocks initialized.
> 
> 2) In the !dioread_nolock case, we allocate blocks, insert an entry to
> the extent tree, write the blocks --- and if we start a commit, we
> write out all dirty pages associated with that inode (in the default
> data=writeback case) to avoid stale writes.
> 
> So what if we change the dioread_nolock case to do write the blocks
> first, and *then* insert the entry into the extent tree?  This avoids
> stale data getting exposed, either by a direct I/O read, or after a
> crash (which means we avoid needing to do the force write-out).
> 
> So what we would need to do is to pass a flag to ext4_map_blocks()
> which causes it to *not* make any on-disk changes.  Instead, it would
> track the fact that blocks have be reserved in the buddy bitmap (this
> is how we prevent blocks from being preallocated after they are
> deleted, but before the transaction has been committed), and the
> location of the assigned blocks in the extent_status tree.  Since no
> on-disk changes are being made, we wouldn't need to hold the
> transaction open.
> 
> Then in the callback after the blocks are written, using the starting
> logical block number stored in the io_end structure, we either convert
> the unwritten extents or actually insert the newly allocated blocks in
> the extent tree and update the on-disk bitmap allocation bitmaps.
> 
> Once we get this working, it should be easy to make dioread_nolock for
> 1k block sizes; it keeps the time that the handle open very short; and
> it completely obviates the need for data=writeback.
> 
> What do folks think?

Hum, so there is the problem that adding extent to the extent tree may need
some block allocations for metadata. So we'd have to carry over delalloc
reservations upto the io-end time. But that should be doable, just needs
some work. Also in the dioread_nolock case we don't have problems with
page lock & page writeback vs transaction start deadlocks as I've described
in my another email regarding ext4_writepages(). So I don't see any hole in
this and the performance should be good. I like this!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
