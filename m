Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBC3C10F0E
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 16:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6C602083E
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 16:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfDGQG5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 7 Apr 2019 12:06:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55752 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726329AbfDGQG5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Apr 2019 12:06:57 -0400
Received: from callcc.thunk.org (189.sub-97-41-144.myvzw.com [97.41.144.189])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x37G6eF3011084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 7 Apr 2019 12:06:47 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id DA506421A12; Sun,  7 Apr 2019 11:55:21 -0400 (EDT)
Date:   Sun, 7 Apr 2019 11:55:21 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Liu Xiang <liu.xiang6@zte.com.cn>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        adilger.kernel@dilger.ca, liuxiang_1999@126.com
Subject: Re: [PATCH v2] ext4: fix prefetchw of NULL page
Message-ID: <20190407155521.GL18897@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Liu Xiang <liu.xiang6@zte.com.cn>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        liuxiang_1999@126.com
References: <1554019894-11041-1-git-send-email-liu.xiang6@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554019894-11041-1-git-send-email-liu.xiang6@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Mar 31, 2019 at 04:11:34PM +0800, Liu Xiang wrote:
> In ext4_mpage_readpages(), if the parameter pages is not NULL, another
> parameter page is NULL. At the first time prefetchw(&page->flags)
> works on NULL. From second time, prefetchw(&page->flags) always works on
> the last consumed page. This might do little improvment for handling
> current page. So prefetchw() should be called while the page pointer
> has just been updated.

Thanks, applied.

					- Ted
