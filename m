Return-Path: <SRS0=fzoK=ZK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1B7C432C0
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Nov 2019 17:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC0E0218AE
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Nov 2019 17:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfKRRUO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Nov 2019 12:20:14 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37626 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726317AbfKRRUO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Nov 2019 12:20:14 -0500
Received: from callcc.thunk.org (guestnat-104-133-8-103.corp.google.com [104.133.8.103] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xAIHK79m003181
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Nov 2019 12:20:09 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id AF2A44202FD; Mon, 18 Nov 2019 12:20:06 -0500 (EST)
Date:   Mon, 18 Nov 2019 12:20:06 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [e2fsprogs PATCH 0/6] chattr.1 updates
Message-ID: <20191118172006.GD27585@mit.edu>
References: <20191118014852.390686-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118014852.390686-1-ebiggers@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Nov 17, 2019 at 05:48:46PM -0800, Eric Biggers wrote:
> This series updates the chattr(1) man page to document the verity file
> attribute ('V'), improve the documentation for the encryption file
> attribute ('E'), and make a few other cleanups.
> 
> Eric Biggers (6):
>   chattr.1: document the verity attribute
>   chattr.1: adjust documentation for encryption attribute
>   chattr.1: add casefold attribute to mode string
>   chattr.1: fix some grammatical errors
>   chattr.1: clarify that ext4 doesn't support tail-merging either
>   chattr.1: say "cleared" instead of "reset"
> 
>  misc/chattr.1.in | 40 +++++++++++++++++++++++++---------------
>  1 file changed, 25 insertions(+), 15 deletions(-)

Thanks for the updates to the chattr man page.  I've applied it to the
maint branch.

				- Ted
