Return-Path: <SRS0=dI79=SX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3094CC10F14
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Apr 2019 13:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8C5E20857
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Apr 2019 13:28:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JxLEvPz0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfDUN2l (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 21 Apr 2019 09:28:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50096 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfDUN2k (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Apr 2019 09:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H++bpboLGE0ZGxThYGaXva5PLIQA/gSdMxbD0eTq8vo=; b=JxLEvPz0WG+qFqbojjeKlj43y0
        9P3bBEVSec+aANadpH7wTNiohoi8pXw4f2LiJBPowb5f0v41cW2icEuCQR3sYLZPRwNGQzL4Fi3aN
        gbSm03b3OAnHP9EPZHHk3hm1954AOmRLr3J6RwY814l00BbsoUTm1s9eQ9uFz8LmVHcW0Eu4TEYUk
        0z9dEEVTjgkkwWQT+piorXGD1b4nBBRTmh7rRtEIHd4OBo0GfpR2Wr1HHf43qlkc8EqUIfcYKZ5Cy
        U+308opOkHLWXpZMe6TJYJ7UX3HAXH7tw3PpU0FCgYb4U13KN/h/2/BpVNpeBBR0w+Nu/8WMIAFaH
        tUaXAw2A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hICWO-0003XL-6K; Sun, 21 Apr 2019 13:28:40 +0000
Date:   Sun, 21 Apr 2019 06:28:40 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Ext4 <linux-ext4@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [aarch64] Kernel crash on v5.1-rc5,
 __arch_copy_from_user+0x1bc/0x240
Message-ID: <20190421132840.GK7751@bombadil.infradead.org>
References: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
 <6a867ea5-c389-30b9-1c84-3be5682146b5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a867ea5-c389-30b9-1c84-3be5682146b5@gmx.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Apr 21, 2019 at 05:12:50PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/21 下午4:20, Qu Wenruo wrote:
> > Hi,
> > 
> > Just hit one crash on v5.1-rc5 kernel, on ext4 filesystem.
> 
> Well, also hit the same one in v5.0.8 kernel.
> 
> Exact the same backtrace.
> 
> Really not sure which part is to blame, ARM or ext4?

You probably have faulty hardware:

https://community.arm.com/developer/ip-products/processors/f/cortex-a-forum/3205/re-what-is-serror-detailed-explanation-is-required

