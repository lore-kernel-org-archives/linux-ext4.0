Return-Path: <SRS0=PW1K=T6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F13C28CC0
	for <linux-ext4@archiver.kernel.org>; Thu, 30 May 2019 21:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55560261AA
	for <linux-ext4@archiver.kernel.org>; Thu, 30 May 2019 21:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfE3VEz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 30 May 2019 17:04:55 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50377 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726079AbfE3VEy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 30 May 2019 17:04:54 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4UL4lVl011453
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 May 2019 17:04:48 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 9286B420481; Thu, 30 May 2019 17:04:47 -0400 (EDT)
Date:   Thu, 30 May 2019 17:04:47 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs] tests: add test for e2fsck of verity file
Message-ID: <20190530210447.GA4885@mit.edu>
References: <20190528231230.234342-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528231230.234342-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, May 28, 2019 at 04:12:30PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Test that e2fsck doesn't report errors when an inode with the 'verity'
> flag has blocks past i_size.
> 
> This is a regression test for commits 3baafde6a8ae ("e2fsck: allow
> verity files to have initialized blocks past i_size") and 43466d039689
> ("e2fsck: handle verity files in scan_extent_node()").
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
