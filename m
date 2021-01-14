Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8BEC433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Jan 2021 03:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2533B2368A
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Jan 2021 03:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbhANDfG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Jan 2021 22:35:06 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36601 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727039AbhANDfG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2021 22:35:06 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 10E3YAaB017414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 22:34:11 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 5774315C3453; Wed, 13 Jan 2021 22:34:10 -0500 (EST)
Date:   Wed, 13 Jan 2021 22:34:10 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Fix wrong list_splice in ext4_fc_cleanup
Message-ID: <X/+7squC5Ikf6Pjp@mit.edu>
References: <CGME20201230094851epcms2p6eeead8cc984379b37b2efd21af90fd1a@epcms2p6>
 <20201230094851epcms2p6eeead8cc984379b37b2efd21af90fd1a@epcms2p6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230094851epcms2p6eeead8cc984379b37b2efd21af90fd1a@epcms2p6>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Dec 30, 2020 at 06:48:51PM +0900, Daejun Park wrote:
> After full/fast commit, entries in staging queue are promoted to main
> queue. In ext4_fs_cleanup function, it splice to staging queue to
> staging queue.
> 
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Thanks, applied.

					- Ted
