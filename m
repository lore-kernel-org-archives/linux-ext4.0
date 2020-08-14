Return-Path: <SRS0=0ZLZ=BY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6928C433DF
	for <linux-ext4@archiver.kernel.org>; Fri, 14 Aug 2020 08:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2F1C2065C
	for <linux-ext4@archiver.kernel.org>; Fri, 14 Aug 2020 08:04:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XbKgvD5N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHNIEV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgHNIEV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Aug 2020 04:04:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D557DC061383;
        Fri, 14 Aug 2020 01:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0+3xhDL/4WjgeMMnwxajsPzOFRVNrrcNRyoY5R2vsxU=; b=XbKgvD5Ns5qVIWXMSkNyyDZ4QJ
        LXOokPrMocLD/2w+l/eBaU98bFSP8MNcDT0uXinGpev0/kLzH9IAy/d4Ay9m6fi9MHbPXvE738R43
        vfAXLCC2l0rxjfiufXoWN2DwPK+sxac0d58v/5h1xi3RwBWnlQEWZkV+h9UexReLXjj+fTp39dJL0
        +T4hwJzFQ4VJ/RDZgP4crext78cPNtbftSP7+igzAX/Zmjp589M1hZ0qLeHV1LV9XxlMb9R8yrqIm
        CAe0FexTU3URzQ1IALFF6R5Dmw0J0si3vfmLTQeoRMh78wyXR4EYjNC/VjS4wtmGpvt8y7h5lLnAZ
        K+F6gU0w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k6Uh2-0003qs-F2; Fri, 14 Aug 2020 08:04:04 +0000
Date:   Fri, 14 Aug 2020 09:04:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jiang Ying <jiangying8582@126.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, wanglong19@meituan.com,
        heguanjun@meituan.com, jack@suse.cz
Subject: Re: [PATCH v4] ext4: fix direct I/O read error
Message-ID: <20200814080404.GA14135@infradead.org>
References: <1596613234-174664-1-git-send-email-jiangying8582@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596613234-174664-1-git-send-email-jiangying8582@126.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Aug 05, 2020 at 03:40:34PM +0800, Jiang Ying wrote:
> This patch is used to fix ext4 direct I/O read error when
> the read size is not aligned with block size.
> 
> Then, I will use a test to explain the error.
> 
> (1) Make a file that is not aligned with block size:
> 	$dd if=/dev/zero of=./test.jar bs=1000 count=3
> 
> (2) I wrote a source file named "direct_io_read_file.c" as following:

Can you please add your reproducer to xfstests?

Thanks!
