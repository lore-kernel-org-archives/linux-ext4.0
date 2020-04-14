Return-Path: <SRS0=nKcX=56=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED29C2BA19
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Apr 2020 07:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14820206E9
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Apr 2020 07:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406234AbgDNHCV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Apr 2020 03:02:21 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:45459 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406221AbgDNHCN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Apr 2020 03:02:13 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id AFDBC240004
        for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2020 07:02:09 +0000 (UTC)
Date:   Tue, 14 Apr 2020 00:02:07 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     linux-ext4@vger.kernel.org
Subject: Inline data with 128-byte inodes?
Message-ID: <20200414070207.GA170659@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Is there a fundamental reason that ext4 *can't* or *shouldn't* support
inline data with 128-byte inodes?

As far as I can tell, the kernel ext4 implementation only allows inline
data with 256-byte or larger inodes, because it requires the system.data
xattr to exist, even if the actual data requires 60 bytes or less. (The
implementation in debugfs, on the other hand, handles inline data in
128-byte inodes just fine. And it seems like it'd be fairly
straightforward to change the kernel implementation to support it as
well.)

For filesystems that don't need to store xattrs in general, and can live
with the other limitations of 128-byte inodes, using a 128-byte inode
can save substantial space compared to a 256-byte inode (many megabytes
worth of inode tables, versus 4k for each file between 61-160 bytes),
and many small files or small directories would still fit in 60 bytes.
