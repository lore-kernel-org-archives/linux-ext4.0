Return-Path: <SRS0=tCIi=4M=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3872FC38BE2
	for <linux-ext4@archiver.kernel.org>; Mon, 24 Feb 2020 19:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02CED20656
	for <linux-ext4@archiver.kernel.org>; Mon, 24 Feb 2020 19:46:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PLn7suk5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgBXTqz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 24 Feb 2020 14:46:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56272 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgBXTqz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Feb 2020 14:46:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tZsP5Q7DHRcaD/4BBG7D9cgOGcqfs0x+4OGKrXrVM8k=; b=PLn7suk5VNzgV3NMDpKR0STPw0
        0ug4F5Zv7iCP2y1nLeHIjXMUQgjK96sVdFI3Ph5TQm06S6nrf5sgUfOYOkNCUzz9/oGlnt1Px1glf
        C4/OSnGg8c2qJn8ignA+jWjocC7hkrvjfroqycOTVFrxdRXrlY2mpu3OLWC6CPZ8ghKwE2dGNxSm2
        kdWNQ5+WmfXAlDdd8DSoJMmdaH6uQchVbDAbklulPdo2IVEm0WURDS+3RJHdzju1gbn33cGsGhgbz
        HjzRX/L67Z6U0Mk4uR3RCbb5h/h5RpqQ8rpygyjgEQGx7B7BGT/VmrB/FkkTkiD5k/sitFSQ2+yy7
        GY1/0fyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6Jgt-0001Wc-Ds; Mon, 24 Feb 2020 19:46:55 +0000
Date:   Mon, 24 Feb 2020 11:46:55 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH] ext2: Silence lockdep warning about reclaim under
 xattr_sem
Message-ID: <20200224194655.GA24741@infradead.org>
References: <20200224125916.17321-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224125916.17321-1-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 24, 2020 at 01:59:16PM +0100, Jan Kara wrote:
> +	/*
> +	 * We are the only ones holding inode reference. The xattr_sem should
> + 	 * better be unlocked! We could as well just not acquire xattr_sem at
> +	 * all but this makes the code more futureproof. OTOH we need trylock
> +	 * here to avoid false-positive warning from lockdep about reclaim
> +	 * circular dependency.
> +	 */
> +	if (WARN_ON(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
> +		return;

Shouldn't this be a WARN_ON_ONCE?  Just in case the impossible happens
that avoids spamming dmesg over and over.
