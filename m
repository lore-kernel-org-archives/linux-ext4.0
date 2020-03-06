Return-Path: <SRS0=/gOX=4X=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A04C3F2CD
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Mar 2020 04:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E873720728
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Mar 2020 04:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgCFEd1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 5 Mar 2020 23:33:27 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47714 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726317AbgCFEd1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2020 23:33:27 -0500
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0264XK3O025045
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 5 Mar 2020 23:33:20 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 1C7EC42045B; Thu,  5 Mar 2020 23:33:20 -0500 (EST)
Date:   Thu, 5 Mar 2020 23:33:20 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Qian Cai <cai@lca.pw>
Cc:     adilger.kernel@dilger.ca, elver@google.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix a data race at inode->i_blocks
Message-ID: <20200306043320.GM20967@mit.edu>
References: <20200222043258.2279-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200222043258.2279-1-cai@lca.pw>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 21, 2020 at 11:32:58PM -0500, Qian Cai wrote:
> inode->i_blocks could be accessed concurrently as noticed by KCSAN,
> 
>  BUG: KCSAN: data-race in ext4_do_update_inode [ext4] / inode_add_bytes
> ...

Thanks, applied.

					- Ted
