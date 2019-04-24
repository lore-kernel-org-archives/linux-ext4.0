Return-Path: <SRS0=cG1U=S2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F5DC10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 14:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11ECA206A3
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 14:24:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cwhCQ1yn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbfDXOYZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 Apr 2019 10:24:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55074 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfDXOYZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Apr 2019 10:24:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ifNgWXvTmgDUGfdyswHI37MtM0BRfvYWXbjcO6UJpe4=; b=cwhCQ1ynmmBQR953/aGcSCeLa
        G3UUnx8QBAcBN3N9rK5idtsNajRPN75ez1leQwUTnd68BuBNBjULyLqUBdZ7u+rNufPcYhO3voqZL
        AcbQJ0XUNJPt98KCYoWVVi0ja/smiSe4fmaQcJtBDPH5VnCg8LmTWalyqEIYNaKGSYGImPqBLyDBR
        R8zQGuNsn6JPJRx/6t6Ju1IcTHJ84RCr63G4nwNcaLgNK3lMpbM+SQSI9+2q8m1yfnDxMZfHVe9eR
        wcUvrBmSdV0wyIlrTnGn2khYB/9K5DzLVjsKi0wS6osAl6OUqByPo7HrkpwA7P5qfhMQwdnRecrsk
        8cwpM7ReQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hJIoy-0004IV-2B; Wed, 24 Apr 2019 14:24:24 +0000
Date:   Wed, 24 Apr 2019 07:24:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: Re: [PATCH V1 02/14] Consolidate "post read processing" into a new
 file
Message-ID: <20190424142423.GA12761@infradead.org>
References: <20190424043730.13683-1-chandan@linux.ibm.com>
 <20190424043730.13683-3-chandan@linux.ibm.com>
 <20190424053544.GA12092@infradead.org>
 <6353008.fQNhCuxumZ@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6353008.fQNhCuxumZ@localhost.localdomain>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 24, 2019 at 03:34:17PM +0530, Chandan Rajendra wrote:
> To clarify, Are you suggesting that a new kconfig option (say
> CONFIG_FS_READ_CALLBACKS) be provided to the user so that the following could
> occur,
> 
> 1. User selects CONFIG_FS_ENCRYPTION and/or CONFIG_FS_VERITY and this causes
> CONFIG_FS_READ_CALLBACKS to be set to 'y'.
> 2. User selects CONFIG_FS_READ_CALLBACKS explicitly.

If you don't add a user description to a Kconfig entry it won't be
visible to users, but only selectable by other options.  That is what
I suggest.
