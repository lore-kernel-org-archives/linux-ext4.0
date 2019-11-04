Return-Path: <SRS0=Qk7k=Y4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5613BCA9ECF
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Nov 2019 03:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AC8121D71
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Nov 2019 03:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbfKDDdA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 3 Nov 2019 22:33:00 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56515 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728762AbfKDDdA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Nov 2019 22:33:00 -0500
Received: from callcc.thunk.org (ip-12-2-52-196.nyc.us.northamericancoax.com [196.52.2.12])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xA43WslA009555
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 3 Nov 2019 22:32:55 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 16364420311; Sun,  3 Nov 2019 22:32:52 -0500 (EST)
Date:   Sun, 3 Nov 2019 22:32:52 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/19 v3] ext4: Fix transaction overflow due to revoke
 descriptors
Message-ID: <20191104033252.GC12046@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003215523.7313-1-jack@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Jan,

I believe that I'm waiting for the v4 version of this series with some
pending fixes that you are planning on making.  Is that correct?

Thanks!!

					- Ted
