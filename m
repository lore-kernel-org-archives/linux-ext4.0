Return-Path: <SRS0=tv+E=2V=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD9CC2D0C8
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Dec 2019 03:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB511206CB
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Dec 2019 03:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfLaDp3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 30 Dec 2019 22:45:29 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36439 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726605AbfLaDp3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Dec 2019 22:45:29 -0500
Received: from callcc.thunk.org (96-72-102-169-static.hfc.comcastbusiness.net [96.72.102.169] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xBV3jL2i007479
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Dec 2019 22:45:22 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 592A9420485; Mon, 30 Dec 2019 22:45:21 -0500 (EST)
Date:   Mon, 30 Dec 2019 22:45:21 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Benno Schulenberg <bensberg@telfort.nl>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] e2image: remove redundant -fr from man page and usage
 message
Message-ID: <20191231034521.GE3669@mit.edu>
References: <20191205175735.28054-1-bensberg@telfort.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205175735.28054-1-bensberg@telfort.nl>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Dec 05, 2019 at 06:57:35PM +0100, Benno Schulenberg wrote:
> Also, add a missing dash and two missing brackets and two missing
> spaces, and remove three excess spaces.
> 
> Signed-off-by: Benno Schulenberg <bensberg@telfort.nl>

Thanks, applied.

					- Ted
