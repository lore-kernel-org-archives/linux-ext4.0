Return-Path: <SRS0=qVE9=ZD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9780C43331
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Nov 2019 10:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3A820856
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Nov 2019 10:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Swru49g7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfKKKga (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Nov 2019 05:36:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57580 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfKKKga (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Nov 2019 05:36:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Swru49g7s+A94QhHKZRBNdA6C
        k60AaFFEPs7AMy17/rEKs+sBONGiV2W42BotF5KCRcdxI+hx/S/PgvVwvbZcjiPZtqFATl74qkZWp
        k6dyUb94on2lnXQ4SY8ws/qbU5lATtgfKAzjXrHL3eTIzLCoJvI2OTxmL/sS+zX7MzL2EeIl1hrF0
        J6gtImUnhDKxgeBu1UlbCjo14cVJdcRPJJSW2zD2niWBiErzo/IK3+yVL25rCY15sC8Yjpbjf1FKw
        GGz2eSTK0O3fIZFrzceSD5Kah6lGgZLSZXZ32PkAJIPYRqR7/rmXmpu5oXfnYEkPVbHUkI965S7PZ
        MNG+g2EJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iU73T-0007BK-Hy; Mon, 11 Nov 2019 10:36:19 +0000
Date:   Mon, 11 Nov 2019 02:36:19 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     darrick.wong@oracle.com, naresh.kamboju@linaro.org,
        hch@infradead.org, ltp@lists.linux.it, linux-next@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chrubis@suse.cz,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        broonie@kernel.org, arnd@arndb.de, lkft-triage@lists.linaro.org,
        linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH] iomap: fix return value of iomap_dio_bio_actor on 32bit
 systems
Message-ID: <20191111103619.GA25583@infradead.org>
References: <20191111083815.GA29540@infradead.org>
 <b757ff64ddf68519fc3d55b66fcd8a1d4b436395.1573467154.git.jstancek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b757ff64ddf68519fc3d55b66fcd8a1d4b436395.1573467154.git.jstancek@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
