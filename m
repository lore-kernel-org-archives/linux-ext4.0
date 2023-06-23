Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3A8EB64D7
	for <linux-ext4@archiver.kernel.org>; Fri, 23 Jun 2023 05:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjFWF5k (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 23 Jun 2023 01:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjFWF5i (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jun 2023 01:57:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4B6A2;
        Thu, 22 Jun 2023 22:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WAQw9ksDKZSEcmQ0DgGrDKx38Y
        nrh//Z6nLkosVpLxJ+AU2GThj99wAyfMI4FnKLtSdSoG7UwTUTCOA9GTh7Y9wpF/McSVEPMHE/JRt
        dKPVpUHyw5AfcvCp+EAq+srRbVKzQbD04g9CAG5NTIWCWjxkt7V4U5HS4oigeBbukhUFWRz+FC7QO
        stlNMDCp536iwr5eqNWuEfP+f2BLp9KfZ+ji/5J1fl1U9rKJLADfqf2Wg2qNigxMm3JII7/m4Rsu5
        H9QoL0R/4pnnZ5r3Qb8iBCgfA1dbatr9iddEvtN+vD7ZUX341M3Ge28j+e6I2Y1ytqx/qNhKSW9Kh
        UqDbXylQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qCZnZ-002eLf-2m;
        Fri, 23 Jun 2023 05:57:33 +0000
Date:   Thu, 22 Jun 2023 22:57:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-ext4@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix warning in blkdev_put()
Message-ID: <ZJU0TcFWhgXzDY1l@infradead.org>
References: <20230622165107.13687-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622165107.13687-1-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
