Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60A0C433E9
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Dec 2020 18:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 841482255F
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Dec 2020 18:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgLVSYa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Dec 2020 13:24:30 -0500
Received: from tina.tse.jus.br ([187.4.152.236]:39522 "EHLO tse.jus.br"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725975AbgLVSYa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Dec 2020 13:24:30 -0500
Received: from EXCH01.tse.gov.br (unknown [10.30.1.221])
        by Forcepoint Email with ESMTP id 89F44C1C139C5995B9E7
        for <linux-ext4@vger.kernel.org>; Tue, 22 Dec 2020 15:16:06 -0300 (-03)
Received: from tsesevinl73.tse.jus.br (10.30.32.51) by EXCH01.tse.gov.br
 (10.30.1.221) with Microsoft SMTP Server (TLS) id 14.2.347.0; Tue, 22 Dec
 2020 15:16:05 -0300
From:   <paulo.alvarez@tse.jus.br>
To:     <linux-ext4@vger.kernel.org>
Subject: e2fsprogs: Add windows IO manager
Date:   Tue, 22 Dec 2020 15:15:49 -0300
Message-ID: <20201222181552.11267-1-paulo.alvarez@tse.jus.br>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.32.51]
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This patch series add an IO manager for Window, it is a first step in
a work that has allowed us to format, read and write to ext4 filesystems
on Windows. Any comments are appreciated.


