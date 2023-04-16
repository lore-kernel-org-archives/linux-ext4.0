Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14764C77B73
	for <linux-ext4@archiver.kernel.org>; Sun, 16 Apr 2023 19:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjDPTcN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 16 Apr 2023 15:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjDPTcL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Apr 2023 15:32:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEF110D4
        for <linux-ext4@vger.kernel.org>; Sun, 16 Apr 2023 12:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7bnjqogqMaCi/oevc5lkPThEQJP7B6dcOQlaBcO5X9o=; b=iRwarQc9WSsIr0BSNYwb+F/4w7
        KIUxI5VUHy9iR3G6jShDshHgUCd+CUjKxq5QgZA8xYMi5OiwZOYrWeKSw7kS/UuuuiJJb5R+yWD6o
        kTIlqc6Flng4oCt4hPJ9ThAdFWoAilyzWYrhLTiCWqbtRcEPqAe+5Ppfrq0LdQ403ml1jq44Fcvnd
        nUt9rpbRhfir9DEc26fnobvBpAzQPYmUVfSj2rSEJE/VbhGZT13NDmHeKppOoRg81/7xjDIed1/UT
        FHT2MDt3gN4C50uigk0613571jn4CqxkGlw514YR+tZCdknQr1DAtV2OrQ8HfHDIQIcv/4MRHEQaF
        2t1DDILg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1po86Y-00Abra-Rh; Sun, 16 Apr 2023 19:32:06 +0000
Date:   Sun, 16 Apr 2023 20:32:06 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [RFCv1 1/4] ext4: kill unused function
 ext4_journalled_write_inline_data
Message-ID: <ZDxNNjmopn0N5xof@casper.infradead.org>
References: <cover.1681669004.git.ritesh.list@gmail.com>
 <672a2ebb430d05f72d36a35341ce805a8a0ea9a6.1681669004.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <672a2ebb430d05f72d36a35341ce805a8a0ea9a6.1681669004.git.ritesh.list@gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 17, 2023 at 12:01:50AM +0530, Ritesh Harjani (IBM) wrote:
> Commit 3f079114bf522 ("ext4: Convert data=journal writeback to use ext4_writepages()")
> Added support for writeback of journalled data into ext4_writepages()
> and killed function __ext4_journalled_writepage() which used to call
> ext4_journalled_write_inline_data() for inline data.
> This function got left over by mistake. Hence kill it's definition as
> no one uses it.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
