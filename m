Return-Path: <SRS0=hrf1=5O=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F99C2D0E8
	for <linux-ext4@archiver.kernel.org>; Sun, 29 Mar 2020 02:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D916820578
	for <linux-ext4@archiver.kernel.org>; Sun, 29 Mar 2020 02:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgC2C3y (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 28 Mar 2020 22:29:54 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48484 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726415AbgC2C3y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Mar 2020 22:29:54 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 02T2TjAB022243
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Mar 2020 22:29:45 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 2740D420EBA; Sat, 28 Mar 2020 22:29:45 -0400 (EDT)
Date:   Sat, 28 Mar 2020 22:29:45 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] ext4: Fix incorrect inodes per group in error message
Message-ID: <20200329022945.GJ53396@mit.edu>
References: <8be03355983a08e5d4eed480944613454d7e2550.1585434649.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8be03355983a08e5d4eed480944613454d7e2550.1585434649.git.josh@joshtriplett.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Mar 28, 2020 at 03:34:15PM -0700, Josh Triplett wrote:
> If ext4_fill_super detects an invalid number of inodes per group, the
> resulting error message printed the number of blocks per group, rather
> than the number of inodes per group. Fix it to print the correct value.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> Fixes: cd6bb35bf7f6d ("ext4: use more strict checks for inodes_per_block on mount")

Applied, thanks.

						- Ted
