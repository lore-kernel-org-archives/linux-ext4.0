Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7335CC433EF
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Sep 2021 07:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A2906112D
	for <linux-ext4@archiver.kernel.org>; Wed, 15 Sep 2021 07:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhIOHCA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 Sep 2021 03:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbhIOHB7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Sep 2021 03:01:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3875EC061574;
        Wed, 15 Sep 2021 00:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=EmP4/ZiTfWHx/8MiE7E2nDQre6o0X7QdlrjIGK58IFc=; b=IedtLFzVCvY2cp6KFC2YFMAu3r
        xw0mclnFSq0KxXKEDkj2T30cYTQe+M5nhx+D/AT+0QwTmhV1T3SZDubU3q5SWOHJjCDGP94npFwTv
        rJotmvDYEHjFl94DPkmsAkLEWNm6W4R9lgR3wwDK+EqDZkMimiIpWxXzCIqU1dPrkrlF1/o/D7Rtf
        94OhSfXPCMYLEjayZ6FxayvDqmfagpUferIKv3qthrSVTRAAWj/QSd3Y+/+2AJpMvfyTBR8pvVi3C
        7ju8flA3qm8mbD1K6nb9UzoKQqqcOR9pcnAug1ddulxrXkXWLGpIjyASBCUXjjhP87VaghWiP++04
        1jcM5VrA==;
Received: from [2001:4bb8:184:72db:8457:d7a:6e21:dd20] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQOtr-00FRT5-LU; Wed, 15 Sep 2021 07:00:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Shreeya Patel <shreeya.patel@collabora.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: unicode cleanups, and split the data table into a separate module v2
Date:   Wed, 15 Sep 2021 08:59:55 +0200
Message-Id: <20210915070006.954653-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi all,

this series is an alternate idea to split the utf8 table into a separate
module which comes together with a lot of cleanups.

Changes since v1:
 - don't uglify the mount time messages from ext4/f2fs

Diffstat:
