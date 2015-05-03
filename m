From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: ext4 crypto: Do not select from EXT4_FS_ENCRYPTION
Date: Sun, 03 May 2015 15:34:14 +0300
Message-ID: <554615C6.1060107@iki.fi>
References: <20150501001855.GA31516@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail3.ippnet.fi ([62.197.168.3]:56236 "EHLO mail3.ippnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbbECNHt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 May 2015 09:07:49 -0400
In-Reply-To: <20150501001855.GA31516@gondor.apana.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

01.05.2015, 03:18, Herbert Xu kirjoitti:
> This patch adds a tristate EXT4_ENCRYPTION to do the selections
> for EXT4_FS_ENCRYPTION because selecting from a bool causes all
> the selected options to be built-in, even if EXT4 itself is a
> module.

Hmm, are you sure?

Since CONFIG_EXT4_FS_ENCRYPTION itself depends on CONFIG_EXT4_FS, the
selector for the selected options becomes (CONFIG_EXT4_FS_ENCRYPTION &&
CONFIG_EXT4_FS && CONFIG_BLOCK).

Per my testing on git master (without this patch), if EXT4_FS=m and
EXT4_FS_ENCRYPTION=y, both "built-in" and "module" options are allowed
for the selected options (checked CONFIG_ENCRYPTED_KEYS myself).

So selector "(A=y && B=m)" results in requirement ">=m", which seems
reasonable (otherwise even just CONFIG_BLOCK=y would force them to y).

Am I missing something or this patch unneeded?


> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index 18228c2..024f228 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -64,8 +64,8 @@ config EXT4_FS_SECURITY
>  	  If you are not using a security module that requires using
>  	  extended attributes for file security labels, say N.
>  
> -config EXT4_FS_ENCRYPTION
> -	bool "Ext4 Encryption"
> +config EXT4_ENCRYPTION
> +	tristate "Ext4 Encryption"
>  	depends on EXT4_FS
>  	select CRYPTO_AES
>  	select CRYPTO_CBC
> @@ -81,6 +81,11 @@ config EXT4_FS_ENCRYPTION
>  	  efficient since it avoids caching the encrypted and
>  	  decrypted pages in the page cache.
>  
> +config EXT4_FS_ENCRYPTION
> +	bool
> +	default y
> +	depends on EXT4_ENCRYPTION
> +
>  config EXT4_DEBUG
>  	bool "EXT4 debugging support"
>  	depends on EXT4_FS
> 


-- 
Anssi Hannula
