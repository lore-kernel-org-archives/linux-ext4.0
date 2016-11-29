From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 2/4] fscrypt: unexport fscrypt_initialize()
Date: Tue, 29 Nov 2016 13:01:40 -0800
Message-ID: <20161129210140.GB52769@google.com>
References: <20161127044155.23022-1-tytso@mit.edu>
 <20161127044155.23022-2-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        jaegeuk@kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:34622 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753933AbcK2VBp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Nov 2016 16:01:45 -0500
Received: by mail-pg0-f44.google.com with SMTP id x23so73363563pgx.1
        for <linux-ext4@vger.kernel.org>; Tue, 29 Nov 2016 13:01:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161127044155.23022-2-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 11:41:53PM -0500, Theodore Ts'o wrote:
> The fscrypt_initalize() function isn't used outside fs/crypto, so
> there's no point making it be an exported symbol.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Reviewed-by: Eric Biggers <ebiggers@google.com>
