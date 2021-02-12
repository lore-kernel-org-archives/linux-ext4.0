Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0B5C4332B
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Feb 2021 16:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93A7264E79
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Feb 2021 16:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhBLQiV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 12 Feb 2021 11:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhBLQgK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Feb 2021 11:36:10 -0500
X-Greylist: delayed 466 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 12 Feb 2021 08:35:29 PST
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07635C061574
        for <linux-ext4@vger.kernel.org>; Fri, 12 Feb 2021 08:35:28 -0800 (PST)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1613147213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TXjRXFkI7OapKWoHgXu6l5CfZVGEll4afx3+ErUfZSw=;
        b=r0G+1/l+ZADe9uKDKyubI1kURYr6M4kGTEdntbcLitUdtpXky1BUlVcXsEHlGl1ifOXlZx
        LAngAFd+loH+8Xq1eKdo3d/F/g73Ar32N8wf15thHlr4tKZDGSbUEL7KFP6J4G5LnkTYip
        8U8hFZFf/oT9CrSN7JfSNHdyOONrGqAGHPOsatI4VDTr040xxRhxq0WHdiyuHAofCtpUuL
        j58zg/xY1vPmuSTopBlnMFO9vJvWdDBaD6t7P9OT1NVF1fpjCOC3LiS7Rjh0gBZDjIh26B
        0ZV0qYgxTywv0isjex2oo0K1tIELHdaPsW2umPCDBArapcMSk+wo2aODdGlO8w==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 12 Feb 2021 11:26:52 -0500
Message-Id: <C97OYMYGRGTR.2FML3EK56EC35@taiga>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        "Ext4 Developers List" <linux-ext4@vger.kernel.org>
Subject: Re: j_recover_fast_commit: : failed on musl-riscv64
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "harshad shirwadkar" <harshadshirwadkar@gmail.com>
References: <C96ZW60NLAQF.1JF09JLHKR51M@taiga> <YCX+Em/EUJJte3x1@mit.edu>
 <C97L5DF7C3QF.H25PQ5ERKEPL@taiga>
 <CAD+ocbxUz1kA_7F3f_xXS6_eVt1c0NeMoMXsBQ7z2LbmrMjgMg@mail.gmail.com>
In-Reply-To: <CAD+ocbxUz1kA_7F3f_xXS6_eVt1c0NeMoMXsBQ7z2LbmrMjgMg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Thanks Harshad! Can you send me your SSH public key off-list?
