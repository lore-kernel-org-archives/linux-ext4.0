Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F28C433C1
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Dec 2020 14:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5352120705
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Dec 2020 14:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgLCOM4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 3 Dec 2020 09:12:56 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56965 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726889AbgLCOM4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Dec 2020 09:12:56 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0B3EBRPi024509
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 3 Dec 2020 09:11:29 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CBF27420136; Thu,  3 Dec 2020 09:11:27 -0500 (EST)
Date:   Thu, 3 Dec 2020 09:11:27 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Xianting Tian <tian.xianting@h3c.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove the null check of bio_vec page
Message-ID: <20201203141127.GF441757@mit.edu>
References: <20201020082201.34257-1-tian.xianting@h3c.com>
 <20201021102503.GC19726@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021102503.GC19726@quack2.suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Oct 21, 2020 at 12:25:03PM +0200, Jan Kara wrote:
> On Tue 20-10-20 16:22:01, Xianting Tian wrote:
> > bv_page can't be NULL in a valid bio_vec, so we can remove the NULL check,
> > as we did in other places when calling bio_for_each_segment_all() to go
> > through all bio_vec of a bio.
> > 
> > Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
> 
> Thanks for the patch. It looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
