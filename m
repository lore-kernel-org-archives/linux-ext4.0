Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84ADC433EF
	for <linux-ext4@archiver.kernel.org>; Fri,  3 Jun 2022 14:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244584AbiFCOkT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 3 Jun 2022 10:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbiFCOkS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jun 2022 10:40:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4EC48E59;
        Fri,  3 Jun 2022 07:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aUeh3TS7yGsWjasgaqZC24BFaRSUEZ62WTQKuLG/trQ=; b=Rqpqty5tCsq2jB3TvZzzfKJD4l
        pb5a7z5ruClsgoUHFfwNxqUKUN7YcBdi3NZa/hveC9iQzmuYkjH0B3pmL8lxBtYU0Q46iJTLOFAl6
        IKeRglu339/99NOmrlt8avDqhCgseACC1zojteE6QfkjcOU18GFeCnUJV2JPGRHNhlyGcNfs27K79
        K8dfWfy9vvXs7/clYWfepxLhev3B0XaWxE/DPMY6hIldB38pXsEtbm2AjBdQK1GigomlRu4+ahAQZ
        SyrgT37FNKsOkuzfHBbjQt8Gl2lPaqd+tJ4eivbFAuFBeSGZVbazqTxsocDxIyjLnxq+6TppM0hZ5
        Ql0o3aOw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nx8TF-007xAb-Kc; Fri, 03 Jun 2022 14:40:13 +0000
Date:   Fri, 3 Jun 2022 15:40:13 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.com>
Subject: generic_quota_read
Message-ID: <YpodTd+YN/FtiaP3@casper.infradead.org>
References: <20220526192910.357055-1-willy@infradead.org>
 <20220526192910.357055-8-willy@infradead.org>
 <YpBlF2xbfL2yY98n@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpBlF2xbfL2yY98n@infradead.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, May 26, 2022 at 10:43:51PM -0700, Christoph Hellwig wrote:
> >  static ssize_t jfs_quota_read(struct super_block *sb, int type, char *data,
> > +			      size_t len, loff_t pos)
>
> And this whole helper is generic now.  It might be worth to move it
> into fs/quota/dquot.c as generic_quota_read.

I've been working on that this week.  Unfortunately, you have to convert
both quota_read and quota_write at the same time, it turns out.  At
least ext4_quota_write() uses the bdev's inode's page cache to back
the buffer_heads, so quota_read() and quota_write() are incoherent
with each other:

00017 gqr: mapping:00000000ee19acfb index:0x1 pos:0x1470 len:0x30
00017 4qw: mapping:000000007f9a811e index:0x18405 pos:0x1440 len:0x30

I don't know if there's a way around this.  Can't really use
read_mapping_folio() on the bdev's inode in generic_quota_read() -- the
blocks for a given page might be fragmented on disk.  I don't know
if there's a way to tell ext4_bread() to use the inode's page cache
instead of the bdev's.  And if we did that, would it even work as
being part of a transaction?

