Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DA2C282DA
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 02:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6F9F213A2
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 02:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfDGCNy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 6 Apr 2019 22:13:54 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49739 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726184AbfDGCNy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Apr 2019 22:13:54 -0400
Received: from callcc.thunk.org (225.sub-174-209-4.myvzw.com [174.209.4.225])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x372DltD018866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 6 Apr 2019 22:13:50 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0F6B3421A08; Sat,  6 Apr 2019 17:52:11 -0400 (EDT)
Date:   Sat, 6 Apr 2019 17:52:11 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] mke2fs: allow 64bit feature without extents
Message-ID: <20190406215210.GC18897@mit.edu>
References: <1553246667-53793-1-git-send-email-adilger@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553246667-53793-1-git-send-email-adilger@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 22, 2019 at 03:24:27AM -0600, Andreas Dilger wrote:
> From: Andreas Dilger <adilger@whamcloud.com>
> 
> The 64bit feature should be allowed without extents to for 32-bit
> metadata_csum checksums to be stored in the group descriptor.
> Change the extents check to check for more than 2^32 blocks instead
> of the 64bit feature flag.  This also avoids warnings later if the
> metadata_csum feature is enabled on a filesystem without 64bit.

So what worries me about this change is if extents aren't enabled, and
we do an online (or off-line) resize such that we now have > 2^32
blocks, things are going to get problematic.  Even if the resize
operation sets the extent feature (which I don't think it will), the
problem is if you have an existing file which is using indirect
blocks, and you try to extend the file and there is simply no blocks
under the 2^32 cutoff, what then?  Some files might get ENOSPC errors
while others will work just fine.

With current versions of e2fsprogs we enable the 64-bit (and
metadata_csum) feature by default, which should avoid all of these
problems.  Sure, that's not going to help older file systems --- but
this patch to mke2fs isn't going to help them, either.

It simplifies our test matrix to simply require the extents feature if
the 64-bit feature is desired.  I'm not sure I see the value in
relaxing this requirement.  Is there a reason why you specifically
want 64bit && !extents && metadata_csum?

					- Ted
