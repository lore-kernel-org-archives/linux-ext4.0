Return-Path: <SRS0=Wcou=6O=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D35C28CBC
	for <linux-ext4@archiver.kernel.org>; Thu, 30 Apr 2020 13:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8047D20774
	for <linux-ext4@archiver.kernel.org>; Thu, 30 Apr 2020 13:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgD3Nt0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:49:26 -0400
Received: from vpsf.regnarg.cz ([37.205.8.125]:50162 "EHLO vpsf.regnarg.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726577AbgD3NtZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 30 Apr 2020 09:49:25 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Apr 2020 09:49:25 EDT
Received: from baerbar.localdomain (unknown [10.17.17.20])
        by vpsf.regnarg.cz (Postfix) with ESMTPS id 14F17222D;
        Thu, 30 Apr 2020 15:44:11 +0200 (CEST)
Date:   Thu, 30 Apr 2020 15:44:09 +0200
From:   Filip =?utf-8?B?xaB0xJtkcm9uc2vDvQ==?= <r.lkml@regnarg.cz>
To:     linux-ext4@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>
Subject: Any way to dump ext4 filesystem without file data blocks? (for later
 analysis)
Message-ID: <20200430134409.i5cxmmnbryx5hbui@baerbar.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

I have experienced several mysterious ext4 issues on remote machines
with poor internet connection (mobile broadband) that are not easily
physically accessible.

I would like to download the filesystem image from the remote machine
for local investigation but the partition is rather large (500GB in
one instance) and I cannot easily upload that much data over the
mobile connection.

Is there any way to extract only filesystem metadata (superblock,
inodes, directory data blocks, etc.) from the partition but not
file data blocks? Ideally so that I could then reconstruct an
identical filesystem image, only with file data blocks zeroed out.

It seems it should be straightforwad to write such a tool but before
I start doing so, I wanted to check whether somebody hasn't already
written one. (It seems this might be a common enough need when
debugging and developing filesystems.) Short googling around and
searching list archive did not reveal anything.

Thanks for any pointers.

Filip Stedronsky
