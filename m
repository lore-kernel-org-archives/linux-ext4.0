From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 1/4] fscrypt: rename get_crypt_info() to
 fscrypt_get_crypt_info()
Date: Tue, 29 Nov 2016 13:00:37 -0800
Message-ID: <20161129210037.GA52769@google.com>
References: <20161127044155.23022-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        jaegeuk@kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161127044155.23022-1-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Nov 26, 2016 at 11:41:52PM -0500, Theodore Ts'o wrote:
> To avoid namespace collisions, rename get_crypt_info() to
> fscrypt_get_crypt_info().  The function is only used inside the
> fs/crypto directory, so declare it in the new header file,
> fscrypt_private.h.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Reviewed-by: Eric Biggers <ebiggers@google.com>
