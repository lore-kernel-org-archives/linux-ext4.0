Return-Path: <SRS0=Z9Kk=WI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305D6C433FF
	for <linux-ext4@archiver.kernel.org>; Mon, 12 Aug 2019 06:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC6382070C
	for <linux-ext4@archiver.kernel.org>; Mon, 12 Aug 2019 06:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T4Eb5Aiw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfHLGr3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 12 Aug 2019 02:47:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39150 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfHLGr2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Aug 2019 02:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BePnk0X3rfDaLaLKHzFIKVX/0zCxcshoDltXUneFxlg=; b=T4Eb5AiwGxnuc5XE45CQgSeib
        Ya+w45XZJHhy3Z0YExqsYjDp0kA7BCXPbTRD9jgn5OPX+KQkjukldzQJpH3M2ZuRONcG+MsORLYQD
        /Lx3G2/vCLZhwqvyZ7oZAdaaJlsL395/Yv5dUN2+yZ4V09bREYMPfpJwCzlueyxdhxMbdvzLumWBU
        bLqjt0ZZAFv81n7jfGcn7tTTfgxI/P+GzrGK2W/y4lVz3vZyhM3zYonLY8ARtuWZ8qqpgp+1puoB1
        nLHQUjfxgySWXaWG7NsXvjvVlQ+iC+uGvvrWqjJzLle1cm3VI8tJ7isdwphd8yv67Qv/adfelqpMZ
        gmM0mK+ww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hx476-0005pt-1P; Mon, 12 Aug 2019 06:47:28 +0000
Date:   Sun, 11 Aug 2019 23:47:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 1/3] ext4: return the extent cache information via fiemap
Message-ID: <20190812064728.GA22302@infradead.org>
References: <20190809181831.10618-1-tytso@mit.edu>
 <20190810073343.GA12777@infradead.org>
 <20190811161508.GA5878@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811161508.GA5878@mit.edu>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Aug 11, 2019 at 12:15:08PM -0400, Theodore Y. Ts'o wrote:
> > Nak.  No weird fs specific fiemap flags that aren't even in the uapi
> > header.  Please provide your own debug only interface.
> 
> I can understand why you don't like this from the principle of the
> thing.

I think mixing up in-kernel temporary state with the on-disk layout
is a bad idea, yes.  I think it is an even worse idea to try to sneak
it in without API review in an undocumented fashion.

> 
> I'll create my own ioctl, and make a copy of ioctl_fiemap() into ext4
> and modify it for my needs.  I was trying to avoid needing to do that,
> since there is plenty of space in the fiemap flags to carve out space
> for file-specific specific flags, and avoiding making extra copies of
> code for the purposes of reuse weighed more heavily than "no
> fs-specific fiemap flags".

I think dumping your internal state is a candidate for debugs, not
a copy of ioctl_fiemap.
