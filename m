Return-Path: <SRS0=6qru=TL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DATE_IN_PAST_12_24,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8CAC04AB1
	for <linux-ext4@archiver.kernel.org>; Sat, 11 May 2019 17:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69A89216C4
	for <linux-ext4@archiver.kernel.org>; Sat, 11 May 2019 17:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfEKRTs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 11 May 2019 13:19:48 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47200 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727620AbfEKRTo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 11 May 2019 13:19:44 -0400
Received: from callcc.thunk.org (rrcs-67-53-55-100.west.biz.rr.com [67.53.55.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4BHJa9A030276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 11 May 2019 13:19:38 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D21C0420026; Fri, 10 May 2019 20:18:40 -0400 (EDT)
Date:   Fri, 10 May 2019 20:18:40 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Chengguang Xu <cgxu519@gmail.com>
Cc:     jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] jbd2: fix potential double free
Message-ID: <20190511001840.GC2534@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Chengguang Xu <cgxu519@gmail.com>, jack@suse.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1557484608-23514-1-git-send-email-cgxu519@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557484608-23514-1-git-send-email-cgxu519@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, May 10, 2019 at 06:36:48PM +0800, Chengguang Xu wrote:
> When fail from creating cache jbd2_inode_cache, we will
> destroy previously created cache jbd2_handle_cache twice.
> This patch fixes it by sperating each cache
> initialization/destruction to individual function.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmail.com>

Thanks, applied.

					- Ted
