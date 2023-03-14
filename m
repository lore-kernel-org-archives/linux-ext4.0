Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F1BC6FD1D
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Mar 2023 22:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjCNWqd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Mar 2023 18:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjCNWqd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Mar 2023 18:46:33 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947B43A85B
        for <linux-ext4@vger.kernel.org>; Tue, 14 Mar 2023 15:46:31 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 32EMkJQY015156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 18:46:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1678833981; bh=EIw3Ie5TxrW1nfO5BfJJMgBnHdIwKHl0l4whmp/KkbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=erYjPhE5URyPdmvcgHk5D/48YoVDe6YsN0iemipQAjDspdPmBCRRFp3AXDmpmjoDO
         mFSnWkyvOvJfb7qFcaqRcIxKJtwBCWnkyTjt4qepNiT1YFPRF0C4DtVIorVIMs+P8/
         W0kw8V7mhM7wLuwMy4PzHrD68A+vi2iFBCi21gL7N2QF5qO13oDvGHZaQrI26YJx57
         5zKbCOsfTtb7mx0fZwwltFuhU8x7hzb4UOEN18R/Yjbs4qkbaB28VNQU2NV2ioWvcA
         88W86lqT3HFEb2Y7Sk+L4m1qoZ9Frb24RkXwqlIhbQ0hPcX7ja8tS8DGeOL3o9M9Rr
         i8iRCCVgUtoNg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 814C715C5830; Tue, 14 Mar 2023 18:46:19 -0400 (EDT)
Date:   Tue, 14 Mar 2023 18:46:19 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 19/31] ext4: Convert ext4_journalled_zero_new_buffers()
 to use a folio
Message-ID: <20230314224619.GF860405@mit.edu>
References: <20230126202415.1682629-1-willy@infradead.org>
 <20230126202415.1682629-20-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126202415.1682629-20-willy@infradead.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 26, 2023 at 08:24:03PM +0000, Matthew Wilcox (Oracle) wrote:
> Remove a call to compound_head().

Same question as with other commits, plus one more; why is it notable
that calls to compound_head() are being reduced.  I've looked at the
implementation, and it doesn't look all _that_ heavyweight....

