Return-Path: <SRS0=kheP=DI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8527EC4741F
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Oct 2020 20:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53FE320739
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Oct 2020 20:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbgJAUvW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 1 Oct 2020 16:51:22 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39349 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727172AbgJAUvR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2020 16:51:17 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 091KpDJL025083
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 1 Oct 2020 16:51:14 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5412542003C; Thu,  1 Oct 2020 16:51:13 -0400 (EDT)
Date:   Thu, 1 Oct 2020 16:51:13 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/4] ext2fs: remove unused variable 'left'
Message-ID: <20201001205113.GQ23474@mit.edu>
References: <20200605081442.13428-1-lczerner@redhat.com>
 <20200605081442.13428-4-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605081442.13428-4-lczerner@redhat.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jun 05, 2020 at 10:14:42AM +0200, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
