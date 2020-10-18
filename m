Return-Path: <SRS0=Pp5x=DZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CACC433DF
	for <linux-ext4@archiver.kernel.org>; Sun, 18 Oct 2020 14:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39C8C21655
	for <linux-ext4@archiver.kernel.org>; Sun, 18 Oct 2020 14:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgJRO0G (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 18 Oct 2020 10:26:06 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50604 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725776AbgJRO0F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2020 10:26:05 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 09IEPvdO008343
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 18 Oct 2020 10:25:58 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5346C420107; Sun, 18 Oct 2020 10:25:57 -0400 (EDT)
Date:   Sun, 18 Oct 2020 10:25:57 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 12/18] ext4: Return error from ext4_readpage
Message-ID: <20201018142557.GH181507@mit.edu>
References: <20201016160443.18685-1-willy@infradead.org>
 <20201016160443.18685-13-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016160443.18685-13-willy@infradead.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Oct 16, 2020 at 05:04:37PM +0100, Matthew Wilcox (Oracle) wrote:
> The error returned from ext4_map_blocks() was being discarded, leading
> to the generic -EIO being returned to userspace.  Now ext4 can return
> more precise errors.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

This change is independent of the synchronous readpage changes,
correct?  Or am I missing something?

Cheers,

					- Ted
