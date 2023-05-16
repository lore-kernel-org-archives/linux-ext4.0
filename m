Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C34C77B7A
	for <linux-ext4@archiver.kernel.org>; Tue, 16 May 2023 19:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjEPTQj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 16 May 2023 15:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjEPTQi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 May 2023 15:16:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CD75FD7;
        Tue, 16 May 2023 12:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MYdY0/TL/SxhvblVOBFSYEEUj69P5VAXfsbdFMz214w=; b=LN7xvhV35vR7Sq626xoKlpiE0g
        QQCxBr6ih+kk0VdYv1+by7tuhT25SWJiicTB3occAD+WkzILQwinJdfgD7LWWtpI82tyalEokM6aU
        Ifr0NQXi0yYFR+XSpn1pTeEcgDG3AedQXIzmGyYoLSjjWAgOEJlutvcutD1IBkEIi3r9MhhS1FGcP
        Fk5PFSL/KTBO0ElnhZYwtv60Px6wcLv+H0t8GvKSMuhd0IDstoIhZcwI0sm1zrk9DafOpJxrfIVAX
        yuLVi/w5TCo8prCDnXxhdVl9rXi0MrQyUAcZzBTsOTVYf+bMxRjrmLhgX48oD4tiqvr3XXtxaFENK
        4YlUzUwg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pz0A0-004Typ-HB; Tue, 16 May 2023 19:16:36 +0000
Date:   Tue, 16 May 2023 20:16:36 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [RFCv2 4/5] ext4: Make mpage_journal_page_buffers use folio
Message-ID: <ZGPWlJWFpoZr0VEI@casper.infradead.org>
References: <cover.1684122756.git.ritesh.list@gmail.com>
 <ebc3ac80e6a54b53327740d010ce684a83512021.1684122756.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebc3ac80e6a54b53327740d010ce684a83512021.1684122756.git.ritesh.list@gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, May 15, 2023 at 04:10:43PM +0530, Ritesh Harjani (IBM) wrote:
> This patch converts mpage_journal_page_buffers() to use folio and also
> removes the PAGE_SIZE assumption.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
