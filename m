Return-Path: <SRS0=lOxl=45=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025D2C10DCE
	for <linux-ext4@archiver.kernel.org>; Thu, 12 Mar 2020 14:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3D2220674
	for <linux-ext4@archiver.kernel.org>; Thu, 12 Mar 2020 14:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgCLOv2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:51:28 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49155 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727072AbgCLOv2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Mar 2020 10:51:28 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 02CEpN2n016869
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Mar 2020 10:51:24 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id AD979420E5E; Thu, 12 Mar 2020 10:51:23 -0400 (EDT)
Date:   Thu, 12 Mar 2020 10:51:23 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Dmitry Monakhov <dmonakhov@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: mark block bitmap corrupted when found instead of
 BUGON
Message-ID: <20200312145123.GG7159@mit.edu>
References: <20200310150156.641-1-dmonakhov@gmail.com>
 <2BF8E155-34A0-4913-9B81-DC6CA1A4F6E0@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2BF8E155-34A0-4913-9B81-DC6CA1A4F6E0@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 10, 2020 at 05:02:26PM -0600, Andreas Dilger wrote:
> On Mar 10, 2020, at 9:01 AM, Dmitry Monakhov <dmonakhov@gmail.com> wrote:
> > 
> > We already has similar code in ext4_mb_complex_scan_group(), but
> > ext4_mb_simple_scan_group() still affected.
> > 
> > Other reports: https://www.spinics.net/lists/linux-ext4/msg60231.html
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@gmail.com>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
