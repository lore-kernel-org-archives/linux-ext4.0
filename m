Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42607C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 20:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FDCE21741
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 20:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552940993;
	bh=Dmlphi4l2Zt8PpWEbiCl/F8vnpJiqjDGGWh6hUHbQAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZGfNhd0geBLS9K/JZ/3R6J/h8FJ4Rd21WhT07NXUExVSddmICFN6GUCvGjhEHkTV3
	 oWRVYv7LxgO4BCcZuhTzA1aKmA8LbmEJe0716pJk3AOOgPKa2d/SCcVlDIGCVhsGtR
	 UHzB/rsTPDGCfmd+Ydg+5IMie/+nZQEQqZZr3dWg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbfCRU3w (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 16:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbfCRU3v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Mar 2019 16:29:51 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E37A920989;
        Mon, 18 Mar 2019 20:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552940991;
        bh=Dmlphi4l2Zt8PpWEbiCl/F8vnpJiqjDGGWh6hUHbQAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fxbp2Kwe3a6Swg9eL/xrLwuumd8A1jQ6Isry5uEYNr2P5uIBIBN0hk8d9GjbY0Ncm
         jRqJ1byWxZ2qUjfGfiUQmx8hcINS5kM0w5rVGpGVIhq0ds5dzOAJukx6HcCnknpcN5
         NAJugmFI1r43MVUBjOOQOQFd7ZhfNPt6li1OPUzQ=
Date:   Mon, 18 Mar 2019 13:29:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH 1/5] fscrypt: clean up and improve dentry revalidation
Message-ID: <20190318202948.GD194307@gmail.com>
References: <20190317200444.5967-1-ebiggers@kernel.org>
 <20190317200444.5967-2-ebiggers@kernel.org>
 <20190317203822.GH2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317203822.GH2217@ZenIV.linux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Mar 17, 2019 at 08:38:22PM +0000, Al Viro wrote:
> On Sun, Mar 17, 2019 at 01:04:40PM -0700, Eric Biggers wrote:
> > +	/*
> > +	 * Ciphertext name; valid if the directory's key is still unavailable.
> > +	 *
> > +	 * Note: since fscrypt forbids rename() on ciphertext names, it should
> > +	 * be safe to access ->d_parent directly here.
> 
> No, it is not.  Again, d_splice_alias() on buggered fs image picking a reference
> to your subdirectory when doing a lookup elsewhere.  It can relocate the
> damn thing, without rename() being allowed for _anything_.

You're talking about directory hard links, right?  E.g. if there's a directory
with two links a/dir and b/dir, and fscrypt_d_revalidate() is running on 'dir'
via a lookup in a/, it could be the case that b/dir is being concurrently looked
up.  Then the concurrent d_splice_alias() will move the whole dentry tree rooted
at 'dir' from a/ to b/ in the dcache.  Okay, it looks like you're right; I'll
update my comment to clarify that dget_parent() is still needed...

- Eric
