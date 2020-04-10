Return-Path: <SRS0=y2Es=52=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AECDC2BB1D
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Apr 2020 03:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C01120BED
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Apr 2020 03:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgDJDwk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 9 Apr 2020 23:52:40 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58928 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728547AbgDJDwk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2020 23:52:40 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 03A3qZKW005022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 9 Apr 2020 23:52:36 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id BB72E42013D; Thu,  9 Apr 2020 23:52:35 -0400 (EDT)
Date:   Thu, 9 Apr 2020 23:52:35 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] ext2fs: Fix error checking in dx_link()
Message-ID: <20200410035235.GK45598@mit.edu>
References: <20200330090932.29445-1-jack@suse.cz>
 <20200330090932.29445-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330090932.29445-2-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 30, 2020 at 11:09:31AM +0200, Jan Kara wrote:
> dx_lookup() uses errcode_t return values. As such anything non-zero is
> an error, not values less than zero. Fix the error checking to avoid
> crashes on corrupted filesystems.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
