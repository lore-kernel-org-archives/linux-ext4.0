Return-Path: <SRS0=9mDZ=64=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0235C433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 14 May 2020 14:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9688020727
	for <linux-ext4@archiver.kernel.org>; Thu, 14 May 2020 14:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgENOsG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 May 2020 10:48:06 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58217 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726582AbgENOsG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2020 10:48:06 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04EEljIR005647
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 10:47:46 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A0760420304; Thu, 14 May 2020 10:47:45 -0400 (EDT)
Date:   Thu, 14 May 2020 10:47:45 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     adilger.kernel@dilger.ca, enwlinux@gmail.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove unnecessary comparisons to bool
Message-ID: <20200514144745.GS1596452@mit.edu>
References: <20200420042918.19459-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420042918.19459-1-yanaijie@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 20, 2020 at 12:29:18PM +0800, Jason Yan wrote:
> Fix the following coccicheck warning:
> 
> fs/ext4/extents_status.c:1057:5-28: WARNING: Comparison to bool
> fs/ext4/inode.c:2314:18-24: WARNING: Comparison to bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied, thanks.

					- Ted
