Return-Path: <SRS0=+gwK=S7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5053C43219
	for <linux-ext4@archiver.kernel.org>; Mon, 29 Apr 2019 00:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A70820656
	for <linux-ext4@archiver.kernel.org>; Mon, 29 Apr 2019 00:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfD2Ai3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Apr 2019 20:38:29 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52217 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726223AbfD2Ai3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Apr 2019 20:38:29 -0400
Received: from callcc.thunk.org (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3T0cNQd022495
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Apr 2019 20:38:25 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0840C420023; Sun, 28 Apr 2019 20:38:23 -0400 (EDT)
Date:   Sun, 28 Apr 2019 20:38:22 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] libext2fs: remove unused variable 'old_flags'
Message-ID: <20190429003822.GH3789@mit.edu>
References: <20190422211136.188952-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190422211136.188952-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 22, 2019 at 02:11:36PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In ext2fs_write_inode2(), the 'old_flags' variable is never used.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied, thanks.

					- Ted
