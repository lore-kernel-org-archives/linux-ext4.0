Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4542DC00140
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Aug 2022 06:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiHUGO7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 21 Aug 2022 02:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiHUGOy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Aug 2022 02:14:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C2320F63;
        Sat, 20 Aug 2022 23:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Hee5baA8G/Tb1eW1PswaoqWbo659LhIRzth23nd69hI=; b=TEzkjmAjFQuuX9pFBpQiT4h9zL
        77ZwQKMWgyojuoTDteUSggUtJXkp5o2QDQ4zboEMgdR08RCl8fRPoDXdQwn1HZTgpWm7d1LMdRgix
        TohM0BGhjA9/RPHkGHoWBPssyRnAkzOzs2E8A8y14s5J107veLvVF3DP0m3QYB68rMO01pt3RaQe2
        dwLm7Zus6gsvcdqoR+3cT5Mz+jjLI6QQo16XQTVCgMjpfLwsSdvh/bt1R4q91ms+GxdsUlMGPnQE+
        N75XSeAFlbzB+KjzI4tdZh8HMvbFenzxs+3AxGkmmy4fm2N0IfCUFdQ+5IUw8eFW5oaKBOo+3Q+hR
        y7PLwE5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oPeEH-006fIc-AK; Sun, 21 Aug 2022 06:14:37 +0000
Date:   Sat, 20 Aug 2022 23:14:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu, jlayton@kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/3] fs: record I_DIRTY_TIME even if inode already has
 I_DIRTY_INODE
Message-ID: <YwHNTSUBEQFPgUhL@infradead.org>
References: <20220812123727.46397-1-lczerner@redhat.com>
 <20220812123727.46397-2-lczerner@redhat.com>
 <YvaYC+LRFqQJT0U9@sol.localdomain>
 <20220816112124.taqvli527475gwv4@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816112124.taqvli527475gwv4@quack3>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Aug 16, 2022 at 01:21:24PM +0200, Jan Kara wrote:
> 2) I_DIRTY_TIME flag passed to ->dirty_inode() callback. This is admittedly
> bit of a hack. Currently XFS relies on the fact that the only time its
> ->dirty_inode() callback needs to do anything is when VFS decides it is
> time to writeback timestamps and XFS detects this situation by checking for
> I_DIRTY_TIME in inode->i_state. Now to fix the race, we need to first clear
> I_DIRTY_TIME in inode->i_state and only then call the ->dirty_inode()
> callback (otherwise timestamp update can get lost). So the solution I've
> suggested was to propagate the information "timestamp update needed" to XFS
> through I_DIRTY_TIME in flags passed to ->dirty_inode().

Maybe we should just add a separate update_lazy_time method to make this
a little more clear?
