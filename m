Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F78CC48BE6
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Jun 2021 23:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45A706105A
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Jun 2021 23:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhFPX3A (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:29:00 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60497 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234508AbhFPX27 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jun 2021 19:28:59 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15GNQhK6031425
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 19:26:43 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id E0A7815C3CB8; Wed, 16 Jun 2021 19:26:42 -0400 (EDT)
Date:   Wed, 16 Jun 2021 19:26:42 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     adilger.kernel@dilger.ca, riteshh@linux.ibm.com,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] ext4: remove redundant check buffer_uptodate()
Message-ID: <YMqIsoyY8iaO/qhP@mit.edu>
References: <1619418587-5580-1-git-send-email-joseph.qi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619418587-5580-1-git-send-email-joseph.qi@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 26, 2021 at 02:29:47PM +0800, Joseph Qi wrote:
> Now set_buffer_uptodate() will test first and then set, so we don't have
> to check buffer_uptodate() first, remove it to simplify code.
> 
> Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Part of this change was already submitted by Yang Guo from Huawei;
I've applied the portion of this patch which is still applicable
(which was for ext4_buffer_uptodate function)

Thanks,

					- Ted
