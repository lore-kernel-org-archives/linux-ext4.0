Return-Path: <SRS0=EIo+=6L=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E102C55199
	for <linux-ext4@archiver.kernel.org>; Mon, 27 Apr 2020 10:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4309920661
	for <linux-ext4@archiver.kernel.org>; Mon, 27 Apr 2020 10:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mp3bYclP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgD0Kud (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 27 Apr 2020 06:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726507AbgD0Kuc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 27 Apr 2020 06:50:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A60C0610D5
        for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2020 03:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=2A7Xi7s3sF49bid21RFRAulD6avmRUux+NN9IZM8s8o=; b=mp3bYclPYPQsNnVmcBBpLd7OgR
        ghbNurvREXauzMWP2vtt88yflnCL5LCNDFPWpN5CgKp/utQ2DARuxaiCQhu4F6IVewQKIAUFtMp1p
        H+rTqlrO3C2L/gmYlKy2omlt2396StNnOYov7LW6Qt1z3DizwFEAwBbJNffoirpSLtS0nRBiOk+AW
        nHYrTJeKL63wg+9aUoRdF+je/CDBwlt2jV8dgCPjG7h1YDdKDVQha9S3lb5afVFhEr/cK+lv4sxjk
        2kr43KFgnC8XphLqj6roHojXhuwwrkdLW3kovQeb2OealhpmEgh1m1yaJxUDVdNmHNdE1NQ0oQoNZ
        mTz7zClA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jT1LM-0001f9-Mp; Mon, 27 Apr 2020 10:50:32 +0000
Date:   Mon, 27 Apr 2020 03:50:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org
Subject: ext4 fiemap and the inode lock
Message-ID: <20200427105032.GA27494@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Ritesh,

before you converted ext4 to use iomap for fiemap, the indirect block
case used generic_block_fiemap and thus took i_rwsem around the 
actual fiemap operation.  Do you remember if you did an audit if it
was ok to drop it, or did that just slip in?
