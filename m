Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBB4C433E6
	for <linux-ext4@archiver.kernel.org>; Fri,  5 Mar 2021 13:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0328164FDF
	for <linux-ext4@archiver.kernel.org>; Fri,  5 Mar 2021 13:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhCENZc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 5 Mar 2021 08:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbhCENZF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Mar 2021 08:25:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E123EC061574;
        Fri,  5 Mar 2021 05:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LU7Uu/G6L4J+ZP2q9hkO7t01RT9Z+lkkDmGXsim3zm4=; b=hJku25DCrH+D7uuuce2/DcyXyC
        Eq1edJUK/ISmJ0lPxZUUFcNuy2uh/2a26AZ0V6+uNPNj2s0jrQ73tfDs2pL2YUlJbcKhBJy8bBb9H
        ljpNQnFih8suino8V+gwYXSgor9rU3lHEKu+AAcO/9cYqF4S/K+WelSXox3eEoO08pwCPiEhkflAS
        o5IpQirkHyGs2gkIBt73gEEUwyJIToYWDDKA6eBvVC1n+KqVEawesyx+R4Z8nhUppERa6J9Npvx3v
        h12yu7wViZakuEszwGHBXWKK2QF08MtkaGdAUBDto2xLh+Hq+iAZAIuWcm8YBsTFIL6gd8xM1uzzi
        C03Nt5+A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lIARe-00BkvL-AN; Fri, 05 Mar 2021 13:24:46 +0000
Date:   Fri, 5 Mar 2021 13:24:42 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, tytso@mit.edu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] block_dump: don't put the last refcount when marking
 inode dirty
Message-ID: <20210305132442.GA2801131@infradead.org>
References: <20210226103103.3048803-1-yi.zhang@huawei.com>
 <20210301112102.GD25026@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301112102.GD25026@quack2.suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 01, 2021 at 12:21:02PM +0100, Jan Kara wrote:
> Hrm, ok. Honestly, I wanted to just delete that code for a long time. IMO
> tracepoints (and we have one in __mark_inode_dirty) are much more useful
> for tracing anyway. This code exists only because it was there much before
> tracepoints existed... Do you have a strong reason why are you using
> block_dump instead of tracepoint trace_writeback_mark_inode_dirty() for
> your monitoring?

Let me play devils advocate here, the downside of the writeback
tracepoints is that they only trace the inode number and not a file name
(component).  Which is also the reason they avoid this problem.

That being said block_dump is a horrible hack, and trace points are the
proper replacement.
