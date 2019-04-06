Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06E9C282DA
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 02:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF3DC2133F
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 02:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfDGCIy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 6 Apr 2019 22:08:54 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49139 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726329AbfDGCIy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Apr 2019 22:08:54 -0400
Received: from callcc.thunk.org (126.sub-97-44-1.myvzw.com [97.44.1.126])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3728k5v017733
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 6 Apr 2019 22:08:49 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 38BAB421A15; Sat,  6 Apr 2019 18:53:39 -0400 (EDT)
Date:   Sat, 6 Apr 2019 18:53:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: remove incorrect comment for NEXT_ORPHAN()
Message-ID: <20190406225339.GF18897@mit.edu>
References: <20190319203818.34159-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319203818.34159-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 19, 2019 at 01:38:18PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The comment above NEXT_ORPHAN() was meant for ext4_encrypted_inode(),
> which was moved by commit a7550b30ab70 ("ext4 crypto: migrate into vfs's
> crypto engine") but the comment was accidentally left in place.  Since
> ext4_encrypted_inode() has now been removed, just remove the comment.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
