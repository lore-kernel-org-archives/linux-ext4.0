Return-Path: <SRS0=bpHE=4B=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C080C3B189
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Feb 2020 15:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E193720675
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Feb 2020 15:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgBMP4O (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 13 Feb 2020 10:56:14 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49707 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729016AbgBMPZ2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Feb 2020 10:25:28 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-101.corp.google.com [104.133.0.101] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01DFPN2R008981
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 10:25:24 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 8008242032C; Thu, 13 Feb 2020 10:25:23 -0500 (EST)
Date:   Thu, 13 Feb 2020 10:25:23 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: don't assume that mmp_nodename/bdevname have NUL
Message-ID: <20200213152523.GB239974@mit.edu>
References: <1579983942-11927-1-git-send-email-adilger@dilger.ca>
 <1580076215-1048-1-git-send-email-adilger@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580076215-1048-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Jan 26, 2020 at 03:03:34PM -0700, Andreas Dilger wrote:
> Don't assume that the mmp_nodename and mmp_bdevname strings are NUL
> terminated, since they are filled in by snprintf(), which is not
> guaranteed to do so.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
