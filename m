Return-Path: <SRS0=JL9M=4R=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D731C3F2CD
	for <linux-ext4@archiver.kernel.org>; Sat, 29 Feb 2020 23:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 450E2222C4
	for <linux-ext4@archiver.kernel.org>; Sat, 29 Feb 2020 23:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgB2Xel (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 29 Feb 2020 18:34:41 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58427 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727205AbgB2Xek (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Feb 2020 18:34:40 -0500
Received: from callcc.thunk.org (205.220.128.199.nw.nuvox.net [205.220.128.199])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01TNYS8T006121
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 29 Feb 2020 18:34:36 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 40CC842045B; Sat, 29 Feb 2020 18:34:28 -0500 (EST)
Date:   Sat, 29 Feb 2020 18:34:28 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@whamcloud.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 6/9] debugfs: print inode numbers as unsigned
Message-ID: <20200229233428.GF38945@mit.edu>
References: <1581037786-62789-1-git-send-email-adilger@whamcloud.com>
 <1581037786-62789-6-git-send-email-adilger@whamcloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581037786-62789-6-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 06, 2020 at 06:09:43PM -0700, Andreas Dilger wrote:
> Print inode numbers as unsigned values, to avoid printing negative
> numbers for inodes above 2B.
> 
> Flags should be printed as hex instead of signed decimal values.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> Lustre-bug-id: https://jira.whamcloud.com/browse/LU-13197

Applied, thanks.

						- Ted
