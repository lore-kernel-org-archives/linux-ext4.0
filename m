Return-Path: <SRS0=DZYj=RU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2DDC43381
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 20:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1780D214AF
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 20:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfCQUi0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Mar 2019 16:38:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37674 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfCQUi0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Mar 2019 16:38:26 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1h5cY2-0003ZP-Lc; Sun, 17 Mar 2019 20:38:22 +0000
Date:   Sun, 17 Mar 2019 20:38:22 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH 1/5] fscrypt: clean up and improve dentry revalidation
Message-ID: <20190317203822.GH2217@ZenIV.linux.org.uk>
References: <20190317200444.5967-1-ebiggers@kernel.org>
 <20190317200444.5967-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317200444.5967-2-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Mar 17, 2019 at 01:04:40PM -0700, Eric Biggers wrote:
> +	/*
> +	 * Ciphertext name; valid if the directory's key is still unavailable.
> +	 *
> +	 * Note: since fscrypt forbids rename() on ciphertext names, it should
> +	 * be safe to access ->d_parent directly here.

No, it is not.  Again, d_splice_alias() on buggered fs image picking a reference
to your subdirectory when doing a lookup elsewhere.  It can relocate the
damn thing, without rename() being allowed for _anything_.
