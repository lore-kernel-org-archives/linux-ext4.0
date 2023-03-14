Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880A0C6FD1F
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Mar 2023 22:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjCNWIa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Mar 2023 18:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjCNWI3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Mar 2023 18:08:29 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E493211FE
        for <linux-ext4@vger.kernel.org>; Tue, 14 Mar 2023 15:08:25 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 32EM8Hc3027717
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 18:08:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1678831699; bh=uTzVv+GLchUoYNO2lcP21RTevceX/z3OHphC4GnsC1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=RG4/tBOU/GN4cTwzuJa2gTrAWXGAtkH/9zMUhlKjzH7QR0sRXn2zkK8TaShsoXT24
         k/YJH6ZJ2NQ5JaVtDZqFWys7Dl7OjWzLMoTxou3WWYVFGJyz8CEh/3NvtOoPGCTI7m
         /jNnaRHr6K7+rShO60LXlKvUQbyP2/xfEUzh4cms+RhtE23047CPCme55i3bYejUse
         Nw3gxuBmDzuM0L/zf06a/SO5xZXXABV6okcQUjp2J4Co4XR7f+ys6VL0wu93xMSO2n
         Ye0B8gKuPATptMeBJShUQSTaFOxWdAuYhPKXMKYFGFVfe4jDr+Ti3jECtZn5QBz+em
         4IM0+qHAyXFsQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6655015C5830; Tue, 14 Mar 2023 18:08:17 -0400 (EDT)
Date:   Tue, 14 Mar 2023 18:08:17 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/31] ext4: Convert ext4_finish_bio() to use folios
Message-ID: <20230314220817.GS860405@mit.edu>
References: <20230126202415.1682629-1-willy@infradead.org>
 <20230126202415.1682629-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126202415.1682629-5-willy@infradead.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 26, 2023 at 08:23:48PM +0000, Matthew Wilcox (Oracle) wrote:
> Prepare ext4 to support large folios in the page writeback path.
> Also set the actual error in the mapping, not just -EIO.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
