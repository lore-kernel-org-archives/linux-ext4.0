From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 1/3] fscrypt: fix loophole in
 one-encryption-policy-per-tree enforcement
Date: Fri, 16 Dec 2016 13:18:46 +0100
Message-ID: <7ed75b90-864a-2dc2-83a0-943c300d0698@nod.at>
References: <1481829584-50218-1-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1481829584-50218-1-git-send-email-ebiggers3@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 15.12.2016 20:19, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Filesystem encryption is designed to enforce that all files in an
> encrypted directory tree use the same encryption policy.  Operations
> that violate this constraint are supposed to fail with EPERM.  There was
> one case that was missed, however: the cross-rename operation (i.e.
> renameat2 with RENAME_EXCHANGE) allowed two files with different
> encryption policies to be exchanged, provided that neither encryption
> key was available.
> 
> To fix this, when we can't compare the fscrypt_info structs because the
> key is unavailable, compare the fscrypt_context structs instead.
> 
> This will be covered by a test in my encryption xfstests patchset.
> 
> Fixes: b7236e21d55f ("ext4 crypto: reorganize how we store keys in the inode")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
