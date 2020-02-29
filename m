Return-Path: <SRS0=JL9M=4R=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71D0C3F2C6
	for <linux-ext4@archiver.kernel.org>; Sat, 29 Feb 2020 23:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FFC7222C2
	for <linux-ext4@archiver.kernel.org>; Sat, 29 Feb 2020 23:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgB2X1e (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 29 Feb 2020 18:27:34 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56988 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726786AbgB2X1e (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Feb 2020 18:27:34 -0500
Received: from callcc.thunk.org (205.220.128.199.nw.nuvox.net [205.220.128.199])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01TNRIZ4004221
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 29 Feb 2020 18:27:29 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E622542045B; Sat, 29 Feb 2020 18:27:16 -0500 (EST)
Date:   Sat, 29 Feb 2020 18:27:16 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@whamcloud.com>
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/9] e2fsck: use proper types for variables
Message-ID: <20200229232716.GB38945@mit.edu>
References: <1581037786-62789-1-git-send-email-adilger@whamcloud.com>
 <1581037786-62789-2-git-send-email-adilger@whamcloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581037786-62789-2-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 06, 2020 at 06:09:39PM -0700, Andreas Dilger wrote:
> Use ext2_ino_t instead of ino_t for referencing inode numbers.
> Use loff_t for for file offsets, and dgrp_t for group numbers.
> 
> Cast products to ssize_t before multiplication to avoid overflow.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> Reviewed-by: Shilong Wang <wshilong@ddn.com>
> Lustre-bug-id: https://jira.whamcloud.com/browse/LU-13197

Applied, thanks.

					- Ted
