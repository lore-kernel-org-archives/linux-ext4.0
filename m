Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5FAC433EF
	for <linux-ext4@archiver.kernel.org>; Sun, 19 Jun 2022 15:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiFSPqV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 19 Jun 2022 11:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiFSPqU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jun 2022 11:46:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E540C65AB;
        Sun, 19 Jun 2022 08:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MxPhQC0Fi/1DMOZlvyotEXGMygrfYcYmw9BH/R1+BPA=; b=QxUVrca29bq4c4uLb+7FFVLG2P
        Wmb/5slT/qsVwGVkMPjkMDNMBEuUHLJWSjs5RmO+hqGaA7EIBqCDB6SEuHb2JEExze92T9tDpajFP
        N5NTd9C0ZN3PMXSUtOC4c6RnqZ2538DT+n+Q3egZDdZEJqQmQpaAyDjnqpZKVZy71Gy87pc3x3Ksi
        LsXw1WvDfjTKhr9e9mILVsy2C6LT7Wg54NqRURIhsU4nz9G4gWG2Iv8AcVocwPPabuxciOTaWSYEa
        coHrqTqoEeEJ6/yOAiayxV8QFPzMaMe5G8TyuCfLO9Xsn+MirVbHJfuUBARLa+C+HMSszkQd13xDS
        1XKZW8sw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o2x7u-004S1a-9R; Sun, 19 Jun 2022 15:46:14 +0000
Date:   Sun, 19 Jun 2022 16:46:14 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jan Kara <jack@suse.com>, Dave Kleikamp <shaggy@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        ntfs3@lists.linux.dev
Subject: Re: remove the nobh helpers v2
Message-ID: <Yq9ExtTRAx1fqORt@casper.infradead.org>
References: <20220613053715.2394147-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613053715.2394147-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jun 13, 2022 at 07:37:09AM +0200, Christoph Hellwig wrote:
> this series (against the pagecache for-next branch) removes the nobh
> helpers which are a variant of the "normal" buffer head helpers with
> special tradeoffs for machines with a lot of highmem, and thus rather
> obsolete.  They pass xfstests, or in case of jfs at least get as far
> as the baseline.

Thanks, applied & pushed out to the for-next branch.
