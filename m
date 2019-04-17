Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DB4C282DA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 13:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C86A920872
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 13:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732317AbfDQNur (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:50:47 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37361 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729453AbfDQNur (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 09:50:47 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3HDoFw8020484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Apr 2019 09:50:16 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 8D935420497; Wed, 17 Apr 2019 09:50:15 -0400 (EDT)
Date:   Wed, 17 Apr 2019 09:50:15 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v2 1/5] fscrypt: clean up and improve dentry revalidation
Message-ID: <20190417135015.GA4686@mit.edu>
References: <20190320183913.12686-1-ebiggers@kernel.org>
 <20190320183913.12686-2-ebiggers@kernel.org>
 <20190416230840.GB14623@mit.edu>
 <20190417001041.GA18090@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417001041.GA18090@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 16, 2019 at 05:10:42PM -0700, Eric Biggers wrote:
> 
> Hi Ted, I assumed you resolved the conflict with "fscrypt: use READ_ONCE() to
> access ->i_crypt_info"?  The code in fscrypt_d_revalidate() should be:
> 
>         dir = dget_parent(dentry);
>         err = fscrypt_get_encryption_info(d_inode(dir));
>         valid = !fscrypt_has_encryption_key(d_inode(dir));
>         dput(dir);

Yes, I did notice the patch conflict.  Thanks for confirming the
correct resolution!

						- Ted
