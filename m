Return-Path: <SRS0=Pl0f=DB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52698C4346E
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Sep 2020 06:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E78E823600
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Sep 2020 06:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HufeTw01"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgIXGOc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Sep 2020 02:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgIXGOc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Sep 2020 02:14:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561ABC0613CE
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2020 23:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D+TOu2srt5VOVE0VxWi+f0Vl3mBQx4wUeJiEQxkwvxw=; b=HufeTw01uTMt//ilJGlEvZDYPz
        +0jUm+R0fsPKg6k7emokrrm15FYZPWnQlxAygahjGQXRjlqPgOw+0+pAnMjPYkL+tfzHhIYFy6jdA
        X+8hSCF+u/C1FgnbaE9h0QZV+YiAz+2L1odokpm2hM51UnsBc54JkD7tcdPbEmDmMxEq9bQrCyTIc
        0T/CwroD45kEoPTRJar72uxw5AYieIY2dJko3tKLKIP7NMTbcpTLRRdAi9zhzpE5JPTMb2zWnBpZ7
        1V8r9Cz+QbQDueoF6W+YXA+fdc5wCKyW+FhjtQVju23nNKadvygeVbKi8BiQNZ93XLAcNcF6JjmPc
        wznD87bg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLKWS-00077q-Oj; Thu, 24 Sep 2020 06:14:28 +0000
Date:   Thu, 24 Sep 2020 07:14:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Meng Wang <meng@hcdatainc.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Keith Busch <kbusch@kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: kernel panics when hot removing U.2 nvme disk
Message-ID: <20200924061428.GA27289@infradead.org>
References: <BYAPR10MB24561C62C45813B7092E346BCB3F0@BYAPR10MB2456.namprd10.prod.outlook.com>
 <20200919014401.GE4030837@dhcp-10-100-145-180.wdl.wdc.com>
 <20200924051230.GA16433@infradead.org>
 <BYAPR10MB245671198E40D4F44B2365C1CB390@BYAPR10MB2456.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR10MB245671198E40D4F44B2365C1CB390@BYAPR10MB2456.namprd10.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Sep 24, 2020 at 05:47:12AM +0000, Meng Wang wrote:
> Thanks for the info. Is it a problem solely for ext4 + nvme combination? If we change file system or use SATA drive, will the problem get workaround?

This will be called for all removals.  I think the root cause probably
is in ext4 where the evict_inode method doesn't properly deal with
non available storage.
