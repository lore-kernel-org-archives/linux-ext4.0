From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/9] string: introduce memweight
Date: Mon, 11 Jun 2012 16:17:25 -0700
Message-ID: <20120611161725.84330925.akpm@linux-foundation.org>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Anders Larsen <al@alarsen.net>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab2FKXR0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2012 19:17:26 -0400
In-Reply-To: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat,  9 Jun 2012 09:50:30 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> memweight() is the function that counts the total number of bits set
> in memory area.  Unlike bitmap_weight(), memweight() takes pointer
> and size in bytes to specify a memory area which does not need to be
> aligned to long-word boundary.
> 
> ...
>
> +/**
> + * memweight - count the total number of bits set in memory area
> + * @ptr: pointer to the start of the area
> + * @bytes: the size of the area
> + */
> +size_t memweight(const void *ptr, size_t bytes)
> +{
> +	size_t w = 0;

Calling the return value "ret" is a useful convention and fits well here.

> +	size_t longs;
> +	const unsigned char *bitmap = ptr;
> +
> +	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
> +			bytes--, bitmap++)
> +		w += hweight8(*bitmap);
> +
> +	longs = bytes / sizeof(long);
> +	if (longs) {
> +		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
> +		w += bitmap_weight((unsigned long *)bitmap,
> +				longs * BITS_PER_LONG);
> +		bytes -= longs * sizeof(long);
> +		bitmap += longs * sizeof(long);
> +	}
> +	/*
> +	 * The reason that this last loop is distinct from the preceding
> +	 * bitmap_weight() call is to compute 1-bits in the last region smaller
> +	 * than sizeof(long) properly on big-endian systems.
> +	 */
> +	for (; bytes > 0; bytes--, bitmap++)
> +		w += hweight8(*bitmap);
> +
> +	return w;
> +}
> +EXPORT_SYMBOL(memweight);

diff -puN lib/string.c~string-introduce-memweight-fix lib/string.c
--- a/lib/string.c~string-introduce-memweight-fix
+++ a/lib/string.c
@@ -833,18 +833,18 @@ EXPORT_SYMBOL(memchr_inv);
  */
 size_t memweight(const void *ptr, size_t bytes)
 {
-	size_t w = 0;
+	size_t ret = 0;
 	size_t longs;
 	const unsigned char *bitmap = ptr;
 
 	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
 			bytes--, bitmap++)
-		w += hweight8(*bitmap);
+		ret += hweight8(*bitmap);
 
 	longs = bytes / sizeof(long);
 	if (longs) {
 		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
-		w += bitmap_weight((unsigned long *)bitmap,
+		ret += bitmap_weight((unsigned long *)bitmap,
 				longs * BITS_PER_LONG);
 		bytes -= longs * sizeof(long);
 		bitmap += longs * sizeof(long);
@@ -855,8 +855,8 @@ size_t memweight(const void *ptr, size_t
 	 * than sizeof(long) properly on big-endian systems.
 	 */
 	for (; bytes > 0; bytes--, bitmap++)
-		w += hweight8(*bitmap);
+		ret += hweight8(*bitmap);
 
-	return w;
+	return ret;
 }
 EXPORT_SYMBOL(memweight);
_

