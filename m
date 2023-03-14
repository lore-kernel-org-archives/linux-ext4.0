Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2599C7618B
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Mar 2023 22:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCNWAx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Mar 2023 18:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjCNWAt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Mar 2023 18:00:49 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82E71CF5A
        for <linux-ext4@vger.kernel.org>; Tue, 14 Mar 2023 15:00:47 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 32EM0NFT023267
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 18:00:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1678831226; bh=jZq2FCAx4+UPVp4fe06+qIqsoofS9s4XGdZFPeH5OGE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=bokdPH+Fpn1j4xkQSq270U3Vdu8wRviAyIrBwsj0RMmKTyCDLeaD/yg5bQPeVBjCN
         EG4dk83O8UhzyyyuJ18o6kV5m1UcUWNtD1Mm+CViUu2fpVC/jmUm8Q9UQEEmef33PI
         awEbBJ0K5rqeBSQI76RjpZqoDnvjSMcz0UGHjROOEjuWE2d9puPSTNJU9ApB6NJJXE
         FPvIb/nsIz/2vEPIRvlug8c+pMfa1Ks1bGkDWf2AMeIWJS/X+NfozdSHJdD1bxoWge
         lOUDM5tW3DfAV9x2oo3ejOG/yOPjGDuAz882KTwHvZkx2zLZiT7wXVnkRln4l93wFk
         4DU+fQhM5uaGA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6061415C5830; Tue, 14 Mar 2023 18:00:23 -0400 (EDT)
Date:   Tue, 14 Mar 2023 18:00:23 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/31] fs: Add FGP_WRITEBEGIN
Message-ID: <20230314220023.GP860405@mit.edu>
References: <20230126202415.1682629-1-willy@infradead.org>
 <20230126202415.1682629-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126202415.1682629-2-willy@infradead.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 26, 2023 at 08:23:45PM +0000, Matthew Wilcox (Oracle) wrote:
> This particular combination of flags is used by most filesystems
> in their ->write_begin method, although it does find use in a
> few other places.  Before folios, it warranted its own function
> (grab_cache_page_write_begin()), but I think that just having specialised
> flags is enough.  It certainly helps the few places that have been
> converted from grab_cache_page_write_begin() to __filemap_get_folio().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
