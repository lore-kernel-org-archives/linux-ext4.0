Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FCCC43470
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Apr 2021 12:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5F4613D0
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Apr 2021 12:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343983AbhDFMWE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:22:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:39256 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343961AbhDFMV6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Apr 2021 08:21:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DA330B165;
        Tue,  6 Apr 2021 12:21:48 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id AF6701F2B77; Tue,  6 Apr 2021 14:21:48 +0200 (CEST)
Date:   Tue, 6 Apr 2021 14:21:48 +0200
From:   Jan Kara <jack@suse.cz>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: Provide address_space operation for filling
 pages for read
Message-ID: <20210406122148.GC19407@quack2.suse.cz>
References: <20210120160611.26853-1-jack@suse.cz>
 <20210120160611.26853-3-jack@suse.cz>
 <20210120162001.GB3790454@infradead.org>
 <YGeJ1hBP3lEMOSA2@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGeJ1hBP3lEMOSA2@moria.home.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 02-04-21 17:17:10, Kent Overstreet wrote:
> On Wed, Jan 20, 2021 at 04:20:01PM +0000, Christoph Hellwig wrote:
> > On Wed, Jan 20, 2021 at 05:06:10PM +0100, Jan Kara wrote:
> > > Provide an address_space operation for filling pages needed for read
> > > into page cache. Filesystems can use this operation to seriealize
> > > page cache filling with e.g. hole punching properly.
> > 
> > Besides the impending rewrite of the area - having another indirection
> > here is just horrible for performance.  If we want locking in this area
> > it should be in core code and common for multiple file systems.
> 
> Agreed.

Please see v2 [1] where the indirection is avoided.

> But, instead of using a rwsemaphore, why not just make it a lock with two shared
> states that are exclusive with each other? One state for things that add pages
> to the page cache, the other state for things that want to prevent that. That
> way, DIO can use it too...

Well, the filesystems I convert use rwsem currently so for the conversion,
keeping rwsem is the simplest. If we then decide for a more fancy locking
primitive (and I agree what you describe should be possible), then we can
do that but IMO that's the next step (because it requires auditing every
filesystem that the new primitive is indeed safe for them).

								Honza

[1] https://lore.kernel.org/linux-fsdevel/20210212160108.GW19070@quack2.suse.cz/
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
