Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A6DC4361B
	for <linux-ext4@archiver.kernel.org>; Thu, 10 Dec 2020 15:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1229123BAB
	for <linux-ext4@archiver.kernel.org>; Thu, 10 Dec 2020 15:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392003AbgLJPtT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 10 Dec 2020 10:49:19 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38436 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390955AbgLJPtO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2020 10:49:14 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0BAFmMjK006942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 10:48:22 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 12C19420136; Thu, 10 Dec 2020 10:48:22 -0500 (EST)
Date:   Thu, 10 Dec 2020 10:48:21 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     harshad shirwadkar <harshadshirwadkar@gmail.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 06/15] ext2fs: add new APIs needed for fast commits
Message-ID: <20201210154821.GR52960@mit.edu>
References: <20201120191606.2224881-1-harshadshirwadkar@gmail.com>
 <20201120191606.2224881-7-harshadshirwadkar@gmail.com>
 <20201202184458.GJ390058@mit.edu>
 <CAD+ocbxTHNDwqyucTif7n65pgiapTH1Exgh6F7fJQNDSkmXEcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD+ocbxTHNDwqyucTif7n65pgiapTH1Exgh6F7fJQNDSkmXEcg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Dec 09, 2020 at 05:45:27PM -0800, harshad shirwadkar wrote:
> I see that makes sense. In that case, I'll rename the function to
> errcode_t ext2fs_decode_extent(struct ext2fs_extent *dst, void *src).
> I wonder if it's okay if we make this function return an error in case
> the on-disk format is not sane. If we do that, we can add
> ext2fs_validate_extent() later. Does that make sense?

Sure, that works for me.

Something that you should think about at some point is how much impact
would be supporting an alternate on-disk extent node structure (for
the leaf and/or intermediate nodes) have on Fast Commit?  Obviously
doing this would a new an INCOMPAT feature at the file system level,
so we probably won't need any additional version negotiation in the
fast commit journal header itself, but how many tags would need to be
changed if we were to extend the extent tree structure sometime in the
future?

Cheers,

						- Ted
