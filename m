Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE7AC67871
	for <linux-ext4@archiver.kernel.org>; Mon, 16 Jan 2023 16:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjAPQLe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 16 Jan 2023 11:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbjAPQK1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jan 2023 11:10:27 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079E023DB2
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2023 08:06:55 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 809FC68AA6; Mon, 16 Jan 2023 17:06:52 +0100 (CET)
Date:   Mon, 16 Jan 2023 17:06:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, jack@suse.com,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: propagate errors from ext2_prepare_chunk
Message-ID: <20230116160652.GA23301@lst.de>
References: <20230116085205.2342975-1-hch@lst.de> <20230116111621.rffhrhkdggszwlnu@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116111621.rffhrhkdggszwlnu@quack3>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 16, 2023 at 12:16:21PM +0100, Jan Kara wrote:
> > -		ext2_set_link(new_dir, new_de, new_page, page_addr, old_inode, 1);
> > +		err = ext2_set_link(new_dir, new_de, new_page, page_addr,
> > +				    old_inode, true);
> > +		if (err)
> > +			goto out_dir;
> >  		ext2_put_page(new_page, page_addr);
> 
> AFAICT we need to call ext2_put_page(new_page, page_addr) also in case of
> error here. I'll fix it up on commit. Thanks for the patch.

Indeed.  I was tricked by out_dir doing the cleanup, but that's for
the old entry.
