Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC73C2B9F4
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 20:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17E5E6044F
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Jun 2021 20:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhFQUZh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:25:37 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45622 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230137AbhFQUZe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2021 16:25:34 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15HKNHjn012476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:23:18 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6AEDF15C3CBA; Thu, 17 Jun 2021 16:23:17 -0400 (EDT)
Date:   Thu, 17 Jun 2021 16:23:17 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     chenyichong <chenyichong@uniontech.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use local variables ei instead of invoking function
 EXT4_I
Message-ID: <YMuvNfv7CWVLvuie@mit.edu>
References: <20210526052930.11278-1-chenyichong@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526052930.11278-1-chenyichong@uniontech.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, May 26, 2021 at 01:29:30PM +0800, chenyichong wrote:
> Signed-off-by: chenyichong <chenyichong@uniontech.com>

Applied, thanks.

					- Ted
