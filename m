Return-Path: <SRS0=JSyQ=7D=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E86C433E1
	for <linux-ext4@archiver.kernel.org>; Thu, 21 May 2020 15:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA04206F6
	for <linux-ext4@archiver.kernel.org>; Thu, 21 May 2020 15:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729938AbgEUPCY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 May 2020 11:02:24 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56791 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728229AbgEUPCX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 May 2020 11:02:23 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04LF2HQm020740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 May 2020 11:02:18 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B06AF420304; Thu, 21 May 2020 11:02:17 -0400 (EDT)
Date:   Thu, 21 May 2020 11:02:17 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix a typo in a comment
Message-ID: <20200521150217.GE2939819@mit.edu>
References: <20200503200647.154701-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200503200647.154701-1-christophe.jaillet@wanadoo.fr>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, May 03, 2020 at 10:06:47PM +0200, Christophe JAILLET wrote:
> s/extnets/extents/
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks, applied.

					- Ted
