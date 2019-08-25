Return-Path: <SRS0=A3mL=WV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B269C3A59E
	for <linux-ext4@archiver.kernel.org>; Sun, 25 Aug 2019 03:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1B3F214AF
	for <linux-ext4@archiver.kernel.org>; Sun, 25 Aug 2019 03:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfHYDNJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 24 Aug 2019 23:13:09 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:34849 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728243AbfHYDNJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Aug 2019 23:13:09 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x7P3Ch3k026346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 24 Aug 2019 23:12:44 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 20B7742049E; Sat, 24 Aug 2019 23:12:43 -0400 (EDT)
Date:   Sat, 24 Aug 2019 23:12:43 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] jbd2: add missing tracepoint for reserved handle
Message-ID: <20190825031243.GA25396@mit.edu>
References: <20190815134446.28547-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815134446.28547-1-xiaoguang.wang@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Aug 15, 2019 at 09:44:46PM +0800, Xiaoguang Wang wrote:
> This issue was found when I use ebpf to trace every jbd2
> handle's running info in dioread_nolock case.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

Thanks, applied.

						- Ted
