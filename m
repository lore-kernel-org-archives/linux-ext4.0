Return-Path: <SRS0=ulCy=ID=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B45C433E0
	for <linux-ext4@archiver.kernel.org>; Fri,  5 Mar 2021 14:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A42D064F48
	for <linux-ext4@archiver.kernel.org>; Fri,  5 Mar 2021 14:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhCEOje (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 5 Mar 2021 09:39:34 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47682 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231195AbhCEOjS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Mar 2021 09:39:18 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 125Ed3LZ025739
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 5 Mar 2021 09:39:03 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id DF72915C3A88; Fri,  5 Mar 2021 09:39:02 -0500 (EST)
Date:   Fri, 5 Mar 2021 09:39:02 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Zhaolong Zhang <zhangzl2013@126.com>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix bh ref count on error paths
Message-ID: <YEJChkXfcN/HCD+Z@mit.edu>
References: <1614678151-70481-1-git-send-email-zhangzl2013@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614678151-70481-1-git-send-email-zhangzl2013@126.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 02, 2021 at 05:42:31PM +0800, Zhaolong Zhang wrote:
> __ext4_journalled_writepage should drop bhs' ref count on error paths
> 
> Signed-off-by: Zhaolong Zhang <zhangzl2013@126.com>

Thanks, applied.

				- Ted
