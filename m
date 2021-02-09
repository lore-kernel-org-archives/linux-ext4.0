Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4C3C433E0
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Feb 2021 04:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78FBB64EB4
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Feb 2021 04:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhBIE0l (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:26:41 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37014 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229843AbhBIEYs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2021 23:24:48 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1194NTJL019830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 8 Feb 2021 23:23:29 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 5598C15C39D8; Mon,  8 Feb 2021 23:23:29 -0500 (EST)
Date:   Mon, 8 Feb 2021 23:23:29 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@whamcloud.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] e2fsck: fix check of directories over 4GB
Message-ID: <YCIOQSLElpGk9rKX@mit.edu>
References: <20210202082549.2936-1-adilger@whamcloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202082549.2936-1-adilger@whamcloud.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 02, 2021 at 01:25:49AM -0700, Andreas Dilger wrote:
> If directories grow larger than 4GB in size with the large_dir
> feature, e2fsck will consider them to be corrupted and clear
> the high bits of the size.
> 
> Since it isn't very common to have directories this large, and
> unlike sparse files that don't have ill effects if the size is
> too large, an too-large directory will have all of the sparse
> blocks filled in by e2fsck, so huge directories should still
> be viewed with suspicion.  Check for consistency between two of
> the three among block count, inode size, and superblock large_dir
> flag before deciding whether the directory inode should be fixed
> or cleared, or if large_dir should be set in the superblock.
> 
> Update the f_recnect_bad test case to match new output.
> 
> Fixes: 49f28a06b738 ("e2fsck: allow to check >2GB sized directory")
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> Lustre-bug-id: https://jira.whamcloud.com/browse/LU-14345
> Change-Id: I1b898cdab95d239ba1a7b37eb96255acadce7057

Thanks, applied.

						- Ted
