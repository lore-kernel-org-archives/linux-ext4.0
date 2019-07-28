Return-Path: <SRS0=XlcQ=VZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA6DC76190
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Jul 2019 15:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 181E02087C
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Jul 2019 15:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfG1PJq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Jul 2019 11:09:46 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55813 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726032AbfG1PJq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Jul 2019 11:09:46 -0400
Received: from callcc.thunk.org (96-72-102-169-static.hfc.comcastbusiness.net [96.72.102.169] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x6SF9SUd026710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Jul 2019 11:09:29 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id BDCE54202F5; Sun, 28 Jul 2019 11:09:27 -0400 (EDT)
Date:   Sun, 28 Jul 2019 11:09:27 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH v7 04/16] fscrypt: add ->ci_inode to fscrypt_info
Message-ID: <20190728150927.GD6088@mit.edu>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726224141.14044-5-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jul 26, 2019 at 03:41:29PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add an inode back-pointer to 'struct fscrypt_info', such that
> inode->i_crypt_info->ci_inode == inode.
> 
> This will be useful for:
> 
> 1. Evicting the inodes when a fscrypt key is removed, since we'll track
>    the inodes using a given key by linking their fscrypt_infos together,
>    rather than the inodes directly.  This avoids bloating 'struct inode'
>    with a new list_head.
> 
> 2. Simplifying the per-file key setup, since the inode pointer won't
>    have to be passed around everywhere just in case something goes wrong
>    and it's needed for fscrypt_warn().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, feel free to add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
