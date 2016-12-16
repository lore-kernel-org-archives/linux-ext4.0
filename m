From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] ubifs: add CONFIG_BLOCK dependency for encryption
Date: Fri, 16 Dec 2016 10:26:35 +0100
Message-ID: <1df9c2e6-fdf8-404d-4678-7b45958f07f3@nod.at>
References: <20161216084231.1637761-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>,
        Randy Dunlap <rdunlap@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754916AbcLPJ0n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 16 Dec 2016 04:26:43 -0500
In-Reply-To: <20161216084231.1637761-1-arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Arnd,

On 16.12.2016 09:42, Arnd Bergmann wrote:
> This came up during the v4.10 merge window:
> 
> warning: (UBIFS_FS_ENCRYPTION) selects FS_ENCRYPTION which has unmet direct dependencies (BLOCK)
> fs/crypto/crypto.c: In function 'fscrypt_zeroout_range':
> fs/crypto/crypto.c:355:9: error: implicit declaration of function 'bio_alloc';did you mean 'd_alloc'? [-Werror=implicit-function-declaration]
>    bio = bio_alloc(GFP_NOWAIT, 1);
> 
> The easiest way out is to limit UBIFS_FS_ENCRYPTION to configurations
> that also enable BLOCK.

Thanks for the fix!
I'll queue this for -rc2.

In the long-run I'd like to remove the CONFIG_BLOCK dependency from fs/crypto/crypto.c
since UBIFS does not use the block related functions at all.

Thanks,
//richard
