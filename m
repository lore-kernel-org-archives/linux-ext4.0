Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B5AC48BE6
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Jun 2021 23:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DA4B610EA
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Jun 2021 23:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhFPXsD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:48:03 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:34108 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231389AbhFPXsD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jun 2021 19:48:03 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15GNjYBQ004246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 19:45:35 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 9069E15C3CB8; Wed, 16 Jun 2021 19:45:34 -0400 (EDT)
Date:   Wed, 16 Jun 2021 19:45:34 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@austin.ibm.com>,
        Alex Tomas <alex@clusterfs.com>, Andrew Morton <akpm@osdl.org>,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2dcfeaf8cb49b05e8f1a@syzkaller.appspotmail.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix kernel infoleak via ext4_extent_header
Message-ID: <YMqNHnTofj9fR8IJ@mit.edu>
References: <20210506185655.7118-1-mail@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506185655.7118-1-mail@anirudhrb.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, May 07, 2021 at 12:26:54AM +0530, Anirudh Rayabharam wrote:
> Initialize eh_generation of struct ext4_extent_header to prevent leaking
> info to userspace. Fixes KMSAN kernel-infoleak bug reported by syzbot at:
> http://syzkaller.appspot.com/bug?id=78e9ad0e6952a3ca16e8234724b2fa92d041b9b8
> 
> Reported-by: syzbot+2dcfeaf8cb49b05e8f1a@syzkaller.appspotmail.com
> Fixes: a86c61812637 ("[PATCH] ext3: add extent map support")
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>

Applied, thanks.

					- Ted
