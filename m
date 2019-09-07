Return-Path: <SRS0=sq9n=XD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=DATE_IN_PAST_12_24,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A24C433EF
	for <linux-ext4@archiver.kernel.org>; Sun,  8 Sep 2019 08:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7461220678
	for <linux-ext4@archiver.kernel.org>; Sun,  8 Sep 2019 08:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfIHIw1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 8 Sep 2019 04:52:27 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36715 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727359AbfIHIw1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Sep 2019 04:52:27 -0400
Received: from callcc.thunk.org (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x888qH17025741
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 8 Sep 2019 04:52:19 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 55520420842; Sat,  7 Sep 2019 12:00:04 -0400 (EDT)
Date:   Sat, 7 Sep 2019 12:00:04 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: disable mount with both dioread_nolock and
 nodelalloc
Message-ID: <20190907160004.GB23683@mit.edu>
References: <20190731130600.7867-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731130600.7867-1-xiaoguang.wang@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jul 31, 2019 at 09:06:00PM +0800, Xiaoguang Wang wrote:
> Mount with both dioread_nolock and nodelalloc will result in huge
> performance drop, which indeed is an known issue, so before we fix
> this issue, currently we disable this behaviour. Below test reproducer
> can reveal this performance drop.

Is it really worth it to disable this combination?  Nothing goes
*wrong* per se; it's just slower than we would like.

	    	     	  	      	 - Ted
