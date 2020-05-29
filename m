Return-Path: <SRS0=2juh=7L=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D9BDC433DF
	for <linux-ext4@archiver.kernel.org>; Fri, 29 May 2020 03:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A88320888
	for <linux-ext4@archiver.kernel.org>; Fri, 29 May 2020 03:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391686AbgE2DPG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 May 2020 23:15:06 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55520 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390190AbgE2DPE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2020 23:15:04 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04T3F0WA026372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 May 2020 23:15:01 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 810BA420304; Thu, 28 May 2020 23:15:00 -0400 (EDT)
Date:   Thu, 28 May 2020 23:15:00 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: don't block for O_DIRECT if IOCB_NOWAIT is set
Message-ID: <20200529031500.GK228632@mit.edu>
References: <76152096-2bbb-7682-8fce-4cb498bcd909@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76152096-2bbb-7682-8fce-4cb498bcd909@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, May 24, 2020 at 04:53:16PM -0600, Jens Axboe wrote:
> Running with some debug patches to detect illegal blocking triggered the
> extend/unaligned condition in ext4. If ext4 needs to extend the file (and
> hence go to buffered IO), or if the app is doing unaligned IO, then ext4
> asks the iomap code to wait for IO completion. If the caller asked for
> no-wait semantics by setting IOCB_NOWAIT, then ext4 should return -EAGAIN
> instead.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Thanks, applied.

					- Ted
