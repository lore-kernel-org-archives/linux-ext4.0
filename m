From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned
 htree hash algorithms
Date: Wed, 22 Oct 2008 17:22:21 -0700
Message-ID: <20081022172221.c1a8c5b5.akpm@linux-foundation.org>
References: <1224560624-9691-1-git-send-email-tytso@mit.edu>
	<1224560624-9691-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYJWAWy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2008 20:22:54 -0400
In-Reply-To: <1224560624-9691-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Oct 2008 23:43:44 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> +	i = le32_to_cpu(es->s_flags);
> +	if (i & EXT2_FLAGS_UNSIGNED_HASH)
> +		sbi->s_hash_unsigned = 3;
> +	else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
> +		char	c;
> +
> +		c = (char) 255;
> +		if (((int) c) == -1) {

arm says

fs/ext3/super.c: In function `ext3_fill_super':
fs/ext3/super.c:1750: warning: comparison is always false due to limited range of data type

Also, is there any way in which this new code can be, umm, cleaned up?
