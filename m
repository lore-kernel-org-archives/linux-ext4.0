Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A90C4320A
	for <linux-ext4@archiver.kernel.org>; Wed, 28 Jul 2021 00:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FDE260F9E
	for <linux-ext4@archiver.kernel.org>; Wed, 28 Jul 2021 00:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhG1AiR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbhG1AiQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jul 2021 20:38:16 -0400
Received: from hoggar.fisica.ufpr.br (hoggar.fisica.ufpr.br [IPv6:2801:82:80ff:7fff::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780ACC061757
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jul 2021 17:38:14 -0700 (PDT)
Received: by hoggar.fisica.ufpr.br (Postfix, from userid 577)
        id 6FBEB363038A; Tue, 27 Jul 2021 21:38:09 -0300 (-03)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=fisica.ufpr.br;
        s=201705; t=1627432689;
        bh=JPfyEEOtYPNDzfqnJx8oHbZPV7DY6Sl3lC4EvaJ0aJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t9TKZbPRkaipRi2HeOZ8axsuar4MQRbYMkZ+Q116A0AwER0KlnRpX5oqJzsTQwVK2
         0nZPvN7bspJrCVP+nPi2NfjZx/8M0tyJ5nvNEIGvkhnzyzel+vRnDGMWJZ8xgVEaXC
         WCSy+yeqgWjjvbcHtrhvxu/1fRG9Fgi5EM54QuPaJgVcRV+bawLANjkAUU2twEeDJx
         1ZMFvQ+d5CC7h+W8RY5m5uDk5bPqZCjLooB0UDbz6LKhvo7u063mojNf1CudI7SB5o
         PD4d0DxX3+EHIHBSw1M7VQaDyYPPHLB9liHTCRxreWSi26EMX2wwseWCMXNCm6DGVJ
         zkB70SAUBGv4w==
Date:   Tue, 27 Jul 2021 21:38:09 -0300
From:   Carlos Carvalho <carlos@fisica.ufpr.br>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: bug with large_dir in 5.12.17
Message-ID: <YQCm8QXdWqDEZ9ed@fisica.ufpr.br>
References: <YPl/boTCfc3rlJLU@fisica.ufpr.br>
 <0FA2DF8F-8F8D-4A54-B21E-73B318C73F4C@dilger.ca>
 <YQBZWuAN+u+Lfhfo@fisica.ufpr.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YQBZWuAN+u+Lfhfo@fisica.ufpr.br>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

To Andreas Dilger (carlos@fisica.ufpr.br) wrote on Tue, Jul 27, 2021 at 04:07:06PM -03:
> > Did you test on any newer kernels than 5.2.17?
> 
> Not yet. The machine is running 5.13.5 now but this particular backup hasn't
> run yet. I'm doing fsck now (takes 4h30) and will launch it again.

The same happens with 5.13.5 after fsck. I didn't check with new directories,
just ran rsync.
