Return-Path: <SRS0=ue5q=TV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC660C04AAF
	for <linux-ext4@archiver.kernel.org>; Tue, 21 May 2019 08:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91E2E2173E
	for <linux-ext4@archiver.kernel.org>; Tue, 21 May 2019 08:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HBJ7MsNn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfEUI2t (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 21 May 2019 04:28:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43554 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfEUI2t (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 21 May 2019 04:28:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dzgDZjQNK4+WfEDvGGwqugQnmKy730vEONl7eH1nok4=; b=HBJ7MsNn+aPvz98REpWd9DgMm
        dmnQ22k0MVUdI1ghk5enllEkjxUbxymVaLD7NVE6XpFXuVuv4deanC9rt+7COcMZ/bSTF3cHs6XrG
        EeZg8OP2FHkZjEbwkKC1aTNGB4Ls0/51AIQzi3f/1Uci5dQ16U1VCCzTGWzYbCKXJmEwGKkHgrvK5
        EoXiYMJYKCyp/V8tyOXRvKhNzvYGACLupH4EflRc6z6y3dqh4E2dd9Tw/PbH2SBxltIIjqpv96KkO
        f46PoXLEVplgIBXtbi95kuZgzMTGZdJsCqab99Yadc2yzaoJ544SH8krtRYiN4SSqSQlm+px8h5ZO
        VZdh3LauA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT08c-0005iu-QJ; Tue, 21 May 2019 08:28:46 +0000
Date:   Tue, 21 May 2019 01:28:46 -0700
From:   'Christoph Hellwig' <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     'Christoph Hellwig' <hch@infradead.org>,
        kanchan <joshi.k@samsung.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        prakash.v@samsung.com, anshul@samsung.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 0/7] Extend write-hint framework, and add write-hint
 for Ext4 journal
Message-ID: <20190521082846.GA11024@infradead.org>
References: <CGME20190425112347epcas2p1f7be48b8f0d2203252b8c9dd510c1b61@epcas2p1.samsung.com>
 <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
 <20190510170249.GA26907@infradead.org>
 <00fb01d50c71$dd358e50$97a0aaf0$@samsung.com>
 <20190520142719.GA15705@infradead.org>
 <20190521082528.GA17709@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521082528.GA17709@quack2.suse.cz>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, May 21, 2019 at 10:25:28AM +0200, Jan Kara wrote:
> performance benefits for some drives. After all you can just think about it
> like RWH_WRITE_LIFE_JOURNAL type of hint available for the kernel...

Except that it actuallys adds a parallel insfrastructure.  A
RWH_WRITE_LIFE_JOURNAL would be much more palatable, but someone needs
to explain how that is:

 a) different from RWH_WRITE_LIFE_SHORT
 b) would not apply to a log/journal maintained in userspace that works
    exactly the same
