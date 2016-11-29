From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 3/4] fscrypt: move non-public structures and constants to
 fscrypt_private.h
Date: Tue, 29 Nov 2016 13:06:58 -0800
Message-ID: <20161129210658.GC52769@google.com>
References: <20161127044155.23022-1-tytso@mit.edu>
 <20161127044155.23022-3-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        jaegeuk@kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:35466 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755976AbcK2VHC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Nov 2016 16:07:02 -0500
Received: by mail-pg0-f47.google.com with SMTP id p66so73414996pga.2
        for <linux-ext4@vger.kernel.org>; Tue, 29 Nov 2016 13:07:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161127044155.23022-3-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 11:41:54PM -0500, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/crypto/crypto.c          |  2 +-
>  fs/crypto/fscrypt_private.h | 71 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/crypto/policy.c          |  2 +-
>  include/linux/fscrypto.h    | 68 ++-----------------------------------------
>  4 files changed, 76 insertions(+), 67 deletions(-)
> 

This looks good to me.  There are however a few other things I think would
belong in the private header too, like the #includes of <linux/key.h> and
<crypto/skcipher.h>, the declaration of 'fscrypt_info_cachep', and some of the
inline functions.

Reviewed-by: Eric Biggers <ebiggers@google.com>
