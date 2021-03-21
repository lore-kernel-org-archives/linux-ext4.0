Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9A1C433E0
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Mar 2021 04:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D466192D
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Mar 2021 04:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCUEjQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 21 Mar 2021 00:39:16 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44369 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229871AbhCUEjG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Mar 2021 00:39:06 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 12L4d2dk014717
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 00:39:02 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id EB48615C39CA; Sun, 21 Mar 2021 00:39:01 -0400 (EDT)
Date:   Sun, 21 Mar 2021 00:39:01 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     harshad shirwadkar <harshadshirwadkar@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: add rename whiteout support for fast commit
Message-ID: <YFbN5ZUtTKwhIaek@mit.edu>
References: <20210316221921.1124955-1-harshadshirwadkar@gmail.com>
 <CAOQ4uxiD8WGLeSftqL6dOfz_kNp+YSE7qfXYG34Pea4j8G7CxA@mail.gmail.com>
 <CAD+ocbzMv6SyUUZFnBE0gTnHf8yvMFfq6Dm9rdnLXoUrh7gYkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD+ocbzMv6SyUUZFnBE0gTnHf8yvMFfq6Dm9rdnLXoUrh7gYkg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Thanks, applied with Amir's suggested commit summary.

						- Ted
