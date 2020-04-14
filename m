Return-Path: <SRS0=nKcX=56=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B27FC2BA2B
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Apr 2020 01:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 255DB2072A
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Apr 2020 01:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgDNB7O (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:59:14 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42405 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727867AbgDNB7O (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Apr 2020 21:59:14 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 03E1x8f5032124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 21:59:09 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 925D042013D; Mon, 13 Apr 2020 21:59:08 -0400 (EDT)
Date:   Mon, 13 Apr 2020 21:59:08 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Michael Forney <mforney@mforney.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] libext2fs: avoid pointer arithmetic on `void *`
Message-ID: <20200414015908.GD90651@mit.edu>
References: <20200405045346.21860-1-mforney@mforney.org>
 <8304797A-1199-45A4-818F-1BBE598C73A6@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8304797A-1199-45A4-818F-1BBE598C73A6@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Apr 05, 2020 at 06:43:09PM -0600, Andreas Dilger wrote:
> On Apr 4, 2020, at 10:53 PM, Michael Forney <mforney@mforney.org> wrote:
> > 
> > The pointer operand to the binary `+` operator must be to a complete
> > object type.
> > 
> > Signed-off-by: Michael Forney <mforney@mforney.org>
> 
> Seems straight forward enough.  Not needed for GCC, but strictly correct.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
