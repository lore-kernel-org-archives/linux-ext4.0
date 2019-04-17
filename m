Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47332C10F13
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 00:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 139922177B
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 00:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555459846;
	bh=9EgjyPTwyBH3hbIjglZPk1qxDWK0l0tAqHzLGYC7bOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NRdOaQVHepyKLkB0tdMgRzeIvFnh1SFCaDc0NQRHg9N8MHQ1De1jkjYHkNJw2E7dP
	 qG9GQUtGotCbW+8WTLfRPYQBoYP4huBDfXzxT2hUS/eyfcr4MffnXUm1ady3Sythyf
	 ikvvLZlA3GbT7b+5ZNbDKLOrK2VJm+5W8hPixDao=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730888AbfDQAKp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 16 Apr 2019 20:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbfDQAKo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Apr 2019 20:10:44 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD2942176F;
        Wed, 17 Apr 2019 00:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555459844;
        bh=9EgjyPTwyBH3hbIjglZPk1qxDWK0l0tAqHzLGYC7bOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OnSwm4q9mAnM9L9uROODGHLzGSntdduItP+X97q8kBJ1shAUGSNZcVVFJZZjeUOjc
         p9ucAr7X6+YqhEnAwmYoqjDmKx1aZ46+ZQPLATvR7zqt7IxCxlsczk8+P5/tM0Uv/V
         7lXCP05DAqnCc94kCwjnaaVzaEnxS3FEOD+St3PQ=
Date:   Tue, 16 Apr 2019 17:10:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v2 1/5] fscrypt: clean up and improve dentry revalidation
Message-ID: <20190417001041.GA18090@gmail.com>
References: <20190320183913.12686-1-ebiggers@kernel.org>
 <20190320183913.12686-2-ebiggers@kernel.org>
 <20190416230840.GB14623@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416230840.GB14623@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 16, 2019 at 07:08:40PM -0400, Theodore Ts'o wrote:
> On Wed, Mar 20, 2019 at 11:39:09AM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Make various improvements to fscrypt dentry revalidation:
> > 
> > - Don't try to handle the case where the per-directory key is removed,
> >   as this can't happen without the inode (and dentries) being evicted.
> > 
> > - Flag ciphertext dentries rather than plaintext dentries, since it's
> >   ciphertext dentries that need the special handling.
> > 
> > - Avoid doing unnecessary work for non-ciphertext dentries.
> > 
> > - When revalidating ciphertext dentries, try to set up the directory's
> >   i_crypt_info to make sure the key is really still absent, rather than
> >   invalidating all negative dentries as the previous code did.  An old
> >   comment suggested we can't do this for locking reasons, but AFAICT
> >   this comment was outdated and it actually works fine.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Looks good, applied.
> 
> 					- Ted

Hi Ted, I assumed you resolved the conflict with "fscrypt: use READ_ONCE() to
access ->i_crypt_info"?  The code in fscrypt_d_revalidate() should be:

        dir = dget_parent(dentry);
        err = fscrypt_get_encryption_info(d_inode(dir));
        valid = !fscrypt_has_encryption_key(d_inode(dir));
        dput(dir);

- Eric
