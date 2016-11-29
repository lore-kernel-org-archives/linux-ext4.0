From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 4/4] fscrypt: move the policy flags and encryption mode
 definitions to uapi header
Date: Tue, 29 Nov 2016 13:30:33 -0800
Message-ID: <20161129213033.GD52769@google.com>
References: <20161127044155.23022-1-tytso@mit.edu>
 <20161127044155.23022-4-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        jaegeuk@kernel.org, Michael Halcrow <mhalcrow@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:35110 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755616AbcK2Vah (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Nov 2016 16:30:37 -0500
Received: by mail-pg0-f42.google.com with SMTP id p66so73599818pga.2
        for <linux-ext4@vger.kernel.org>; Tue, 29 Nov 2016 13:30:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161127044155.23022-4-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 11:41:55PM -0500, Theodore Ts'o wrote:
> These constants are part of the UAPI, so they belong in
> include/uapi/linux/fs.h instead of include/linux/fscrypto.h
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  include/linux/fscrypto.h | 14 --------------
>  include/uapi/linux/fs.h  | 14 ++++++++++++++
>  2 files changed, 14 insertions(+), 14 deletions(-)
> 

This looks fine to me.  I had wanted to do this a while back, but there was some
talk about exposing the modes under names that hide the specific algorithms,
like "CRYPT_SW_V1", with the assumption being that users shouldn't have to know
about any specific modes but rather simply choose the modes with the highest
version numbers, which would also be the most secure.  But I wasn't really
convinced by that argument because people might add or use specific modes for
reasons other than security, such as hardware support on a certain platform.
And I think a better solution to the "use the most secure mode the kernel knows
about" problem would be to implement a special mode like
FS_ENCRYPTION_MODE_MOST_SECURE which the kernel would translate into its
preferred mode when setting an encryption policy.

Mike, do you have a different opinion?

I should also mention that the UAPI header is also missing struct fscrypt_key
and its the definitions FS_MAX_KEY_SIZE, FS_KEY_DESC_PREFIX, and
FS_KEY_DESC_PREFIX_SIZE.  I think those should be moved to the UAPI header too,
though that can be a separate patch.

Reviewed-by: Eric Biggers <ebiggers@google.com>

Eric
