Return-Path: <SRS0=/gOX=4X=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C0CC3F2D7
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Mar 2020 04:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B0CD2073D
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Mar 2020 04:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCFEeS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 5 Mar 2020 23:34:18 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48037 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726251AbgCFEeS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2020 23:34:18 -0500
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0264YCcg025240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 5 Mar 2020 23:34:12 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0A1C542045B; Thu,  5 Mar 2020 23:34:12 -0500 (EST)
Date:   Thu, 5 Mar 2020 23:34:12 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix a data race at inode->i_disksize
Message-ID: <20200306043412.GN20967@mit.edu>
References: <1582556566-3909-1-git-send-email-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582556566-3909-1-git-send-email-hqjagain@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 24, 2020 at 11:02:46PM +0800, Qiujun Huang wrote:
> KCSAN find inode->i_disksize could be accessed concurrently.
> 
> BUG: KCSAN: data-race in ext4_mark_iloc_dirty / ext4_write_end
> ...

Thanks, applied.

					- Ted
