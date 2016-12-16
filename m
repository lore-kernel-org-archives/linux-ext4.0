From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 3/3] fscrypt: consolidate fscrypt_has_permitted_context()
 checks
Date: Fri, 16 Dec 2016 13:22:51 +0100
Message-ID: <5de5b934-5709-ca29-c277-99d93539b1c0@nod.at>
References: <1481829584-50218-1-git-send-email-ebiggers3@gmail.com>
 <1481829584-50218-3-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1759577AbcLPMWy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 16 Dec 2016 07:22:54 -0500
In-Reply-To: <1481829584-50218-3-git-send-email-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 15.12.2016 20:19, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Now that fscrypt_has_permitted_context() compares the fscrypt_context
> rather than the fscrypt_info when needed, it is no longer necessary to
> delay fscrypt_has_permitted_context() from ->lookup() to ->open() for
> regular files, as introduced in commit ff978b09f973 ("ext4 crypto: move
> context consistency check to ext4_file_open()").  Therefore the check in
> ->open(), along with the dget_parent() hack, can be removed.
> 
> It's also no longer necessary to check the file type before calling
> fscrypt_has_permitted_context().
> 
> This patch makes these changes for both ext4 and f2fs.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/ext4/file.c  | 12 ------------
>  fs/ext4/namei.c | 10 ++--------
>  fs/f2fs/file.c  | 15 +++++----------
>  fs/f2fs/namei.c |  7 ++-----
>  4 files changed, 9 insertions(+), 35 deletions(-)

Can please also take care of UBIFS? :-)

Thanks,
//richard
