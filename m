From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] fscrypto: remove unneeded Kconfig dependencies
Date: Mon, 24 Oct 2016 22:41:08 +0200
Message-ID: <c1c3502a-0364-fc31-fa7f-19125f7e0413@nod.at>
References: <1477340226-144248-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1477340226-144248-1-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 24.10.2016 22:17, Eric Biggers wrote:
> SHA256 and ENCRYPTED_KEYS are not needed.  CTR shouldn't be needed
> either, but I left it for now because it was intentionally added by
> commit 71dea01ea2ed ("ext4 crypto: require CONFIG_CRYPTO_CTR if ext4
> encryption is enabled").  So it sounds like there may be a dependency
> problem elsewhere, which I have not been able to identify specifically,
> that must be solved before CTR can be removed.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Richard Weinberger <richard@nod.at>

FWIW, Strictly speaking we could also get rid of the dependency on BLOCK.
Only very few functions in fs/crypto/crypto.c use block specific functions,
these could be placed in a different file.
The use case would be very small systems with UBIFS and encrypted files.
i.e. kexec() style bootloaders.

Thanks,
//richard
