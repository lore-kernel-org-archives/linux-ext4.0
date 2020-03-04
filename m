Return-Path: <SRS0=zRV+=4V=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94056C3F2D1
	for <linux-ext4@archiver.kernel.org>; Wed,  4 Mar 2020 23:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 737E220842
	for <linux-ext4@archiver.kernel.org>; Wed,  4 Mar 2020 23:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388493AbgCDX1S (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 4 Mar 2020 18:27:18 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37987 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388425AbgCDX1S (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2020 18:27:18 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-105.corp.google.com [104.133.0.105] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 024NRC6M012906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 4 Mar 2020 18:27:13 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5639242045B; Wed,  4 Mar 2020 18:27:12 -0500 (EST)
Date:   Wed, 4 Mar 2020 18:27:12 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@whamcloud.com>
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 9/9] misc: handle very large files with filefrag
Message-ID: <20200304232712.GH74069@mit.edu>
References: <1581037786-62789-1-git-send-email-adilger@whamcloud.com>
 <1581037786-62789-9-git-send-email-adilger@whamcloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581037786-62789-9-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 06, 2020 at 06:09:46PM -0700, Andreas Dilger wrote:
> Avoid overflowing the column-width calc printing files over 4B blocks.
> 
> Document the [KMG] suffixes for the "-b <blocksize>" option.
> 
> The blocksize is limited to at most 1GiB blocksize to avoid shifting
> all extents down to zero GB in size.  Even the use of 1GB blocksize
> is unlikely, but non-ext4 filesystems may use multi-GB extents.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> Lustre-bug-id: https://jira.whamcloud.com/browse/LU-13197

Applied, thanks.

				- Ted
