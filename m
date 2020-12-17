Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E702C2BB40
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Dec 2020 06:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E171C2388A
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Dec 2020 06:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgLQG16 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:27:58 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:43287 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725930AbgLQG1z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Dec 2020 01:27:55 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0BH6Px1P004685
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 01:26:00 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id BFF8E420280; Thu, 17 Dec 2020 01:25:59 -0500 (EST)
Date:   Thu, 17 Dec 2020 01:25:59 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     chenlei0x@gmail.com
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lei Chen <lennychen@tencent.com>
Subject: Re: [PATCH] fs: ext4: remove unnecessary wbc parameter from
 ext4_bio_write_page
Message-ID: <X9r59yLN+NABG0p4@mit.edu>
References: <1607669664-25656-1-git-send-email-lennychen@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607669664-25656-1-git-send-email-lennychen@tencent.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Dec 11, 2020 at 02:54:24PM +0800, chenlei0x@gmail.com wrote:
> From: Lei Chen <lennychen@tencent.com>
> 
> ext4_bio_write_page does not need wbc parameter, since its parameter
> io contains the io_wbc field. The io::io_wbc is initialized by
> ext4_io_submit_init which is called in ext4_writepages and
> ext4_writepage functions prior to ext4_bio_write_page.
> Therefor, when ext4_bio_write_page is called, wbc info
> has already been included in io parameter.
> 
> Signed-off-by: Lei Chen <lennychen@tencent.com>

Thanks, applied.

					- Ted
