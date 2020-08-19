Return-Path: <SRS0=5xRJ=B5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47164C433DF
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Aug 2020 03:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D8DA207BB
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Aug 2020 03:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgHSD4J (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:56:09 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45354 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726342AbgHSD4J (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Aug 2020 23:56:09 -0400
Received: from callcc.thunk.org (pool-108-49-65-20.bstnma.fios.verizon.net [108.49.65.20])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 07J3nYCP011493
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 23:49:36 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 9404A420DC0; Tue, 18 Aug 2020 23:49:34 -0400 (EDT)
Date:   Tue, 18 Aug 2020 23:49:34 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     brookxu <brookxu.cn@gmail.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        riteshh@linux.ibm.com
Subject: Re: [PATCH v3] ext4: fix log printing of ext4_mb_regular_allocator()
Message-ID: <20200819034934.GE162457@mit.edu>
References: <0a165ac0-1912-aebd-8a0d-b42e7cd1aea1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a165ac0-1912-aebd-8a0d-b42e7cd1aea1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Aug 15, 2020 at 08:10:44AM +0800, brookxu wrote:
> Fix log printing of ext4_mb_regular_allocator()，it may be an
> unintentional behavior.

Thanks, applied with Andreas's suggested improvement and with a
reworded commit description.

					- Ted
