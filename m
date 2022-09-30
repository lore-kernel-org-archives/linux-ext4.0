Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F251BC4332F
	for <linux-ext4@archiver.kernel.org>; Fri, 30 Sep 2022 03:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiI3DUC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 29 Sep 2022 23:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiI3DT6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2022 23:19:58 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965FD2253C
        for <linux-ext4@vger.kernel.org>; Thu, 29 Sep 2022 20:19:54 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 28U3Jlir002409
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 23:19:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1664507989; bh=DD9FGOxQACkAQcGRJt+qd4WJy0wpwTmqGsoEmb+vaZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=M4K/JKjk5fhKlJ6iKmKT5iaovR3IBqDTv+N+zOKRzpY6l1UYYxPYCn9a1zUzFaakp
         DvOPIteYPsGjLjNbTa9GwceWJY/z3YBclk1tqomRoSZyKJTsQRahhk4xxfVecLh2kG
         4KMZswbdGcYHsscm6jjaB++ZG+vzpE30aEuYz2qj07gwtFUh3VZLarr/X6ccdj3atW
         x2feiFN0BsojfYx6gMc37srdD2hyPI0vgIUmWfVhguTHeIoMdBq45sGy/K4O5Pvkeh
         6goWzwgogTR/dkOFyvqd3PHBfEUeI+avlenOrz2O85pqfcAZozjNW1n4xbKL4nNxmq
         hOXEpjMFAk9cA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 88CFF15C33A3; Thu, 29 Sep 2022 23:19:47 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-ext4@vger.kernel.org, adilger@dilger.ca,
        artem.blagodarenko@gmail.com, alexey.lyashkov@gmail.com
Cc:     "Theodore Ts'o" <tytso@mit.edu>, anserper@ya.ru,
        ritesh.list@gmail.com
Subject: Re: [PATCH] jbd2: wake up journal waiters in FIFO order, not LIFO
Date:   Thu, 29 Sep 2022 23:19:31 -0400
Message-Id: <166450797716.256913.3257351603456798728.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220912180137.2308900-1-alexey.lyashkov@gmail.com>
References: <20220912180137.2308900-1-alexey.lyashkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, 12 Sep 2022 21:01:37 +0300, Alexey Lyashkov wrote:
> From: Andrew Perepechko <anserper@ya.ru>
> 
> LIFO wakeup order is unfair and sometimes leads to a journal
> user not being able to get a journal handle for hundreds of
> transactions in a row.
> 
> FIFO wakeup can make things more fair.
> 
> [...]

Applied, thanks!

[1/1] jbd2: wake up journal waiters in FIFO order, not LIFO
      commit: 2bf6739025dcfca3a24fbc73b8f2dbd979c0e4c9

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
