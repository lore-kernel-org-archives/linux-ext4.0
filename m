Return-Path: <SRS0=vRiw=7A=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB3DC433DF
	for <linux-ext4@archiver.kernel.org>; Mon, 18 May 2020 01:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E5D2070A
	for <linux-ext4@archiver.kernel.org>; Mon, 18 May 2020 01:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgERB4g (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 May 2020 21:56:36 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52773 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726680AbgERB4f (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 17 May 2020 21:56:35 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04I1uUPw016173
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 17 May 2020 21:56:31 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 54EB1420304; Sun, 17 May 2020 21:56:30 -0400 (EDT)
Date:   Sun, 17 May 2020 21:56:30 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: handle ext4_mark_inode_dirty errors
Message-ID: <20200518015630.GA2339693@mit.edu>
References: <20200427013438.219117-1-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427013438.219117-1-harshadshirwadkar@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Apr 26, 2020 at 06:34:37PM -0700, Harshad Shirwadkar wrote:
> ext4_mark_inode_dirty() can fail for real reasons. Ignoring its return
> value may lead ext4 to ignore real failures that would result in
> corruption / crashes. Harden ext4_mark_inode_dirty error paths to fail
> as soon as possible and return errors to the caller whenever
> appropriate.
> 
> One of the possible scnearios when this bug could affected is that
> while creating a new inode, its directory entry gets added
> successfully but while writing the inode itself mark_inode_dirty
> returns error which is ignored. This would result in inconsistency
> that the directory entry points to a non-existent inode.
> 
> Ran gce-xfstests smoke tests and verified that there were no
> regressions.
> 
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

Applied, thanks.

						- Ted
