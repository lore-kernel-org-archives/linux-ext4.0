Return-Path: <SRS0=bpHE=4B=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF02BC2BA83
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Feb 2020 15:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFEF92168B
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Feb 2020 15:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgBMPOi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 13 Feb 2020 10:14:38 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46937 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727414AbgBMPOi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Feb 2020 10:14:38 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-101.corp.google.com [104.133.0.101] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01DFEXpn005327
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 10:14:33 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id AE7D342032C; Thu, 13 Feb 2020 10:14:32 -0500 (EST)
Date:   Thu, 13 Feb 2020 10:14:32 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: simplify checking quota limits in ext4_statfs()
Message-ID: <20200213151432.GA288055@mit.edu>
References: <20200130111148.10766-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130111148.10766-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 30, 2020 at 12:11:48PM +0100, Jan Kara wrote:
> Coverity reports that conditions checking quota limits in ext4_statfs()
> contain dead code. Indeed it is right and current conditions can be
> simplified.
> 
> Reported-by: Coverity <scan-admin@coverity.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
