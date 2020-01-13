Return-Path: <SRS0=Aflh=3C=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52517C33CAF
	for <linux-ext4@archiver.kernel.org>; Mon, 13 Jan 2020 21:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 305BA2084D
	for <linux-ext4@archiver.kernel.org>; Mon, 13 Jan 2020 21:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgAMVdE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 13 Jan 2020 16:33:04 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49589 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726778AbgAMVdE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jan 2020 16:33:04 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00DLWxq7015587
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 16:33:00 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 337464207DF; Mon, 13 Jan 2020 16:32:59 -0500 (EST)
Date:   Mon, 13 Jan 2020 16:32:59 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/8] ext4: extents.c cleanups
Message-ID: <20200113213259.GI76141@mit.edu>
References: <20191231180444.46586-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231180444.46586-1-ebiggers@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Dec 31, 2019 at 12:04:36PM -0600, Eric Biggers wrote:
> This series makes a few cleanups to things I noticed while reading some
> of the code in extents.c.
> 
> No actual changes in behavior.
> 
> Eric Biggers (8):
>   ext4: remove ext4_{ind,ext}_calc_metadata_amount()
>   ext4: clean up len and offset checks in ext4_fallocate()
>   ext4: remove redundant S_ISREG() checks from ext4_fallocate()
>   ext4: make some functions static in extents.c
>   ext4: fix documentation for ext4_ext_try_to_merge()
>   ext4: remove obsolete comment from ext4_can_extents_be_merged()
>   ext4: fix some nonstandard indentation in extents.c
>   ext4: add missing braces in ext4_ext_drop_refs()
> 
>  fs/ext4/ext4.h         |  11 ----
>  fs/ext4/ext4_extents.h |   5 --
>  fs/ext4/extents.c      | 143 +++++++++++++----------------------------
>  fs/ext4/indirect.c     |  26 --------
>  fs/ext4/inode.c        |   3 -
>  fs/ext4/super.c        |   2 -
>  6 files changed, 45 insertions(+), 145 deletions(-)

Thanks for the cleanup patches, and thanks to Ritesh and Jan for
reviewing them!  I've applied them to the ext4.git tree.

	  	      	      	      - Ted
