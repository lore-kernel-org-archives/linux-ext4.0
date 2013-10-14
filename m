From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 04/22] libext2fs: handle inline data in dir iterator
 function
Date: Sun, 13 Oct 2013 21:58:11 -0400
Message-ID: <20131014015811.GB25013@thunk.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-5-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45645 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab3JNB6O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Oct 2013 21:58:14 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-5-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:49:31PM +0800, Zheng Liu wrote:
> diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> index 7e6d6e5..8a19cab 100644
> --- a/lib/ext2fs/ext2_err.et.in
> +++ b/lib/ext2fs/ext2_err.et.in
> @@ -68,6 +68,9 @@ ec	EXT2_ET_MAGIC_EXTENT_HANDLE,
>  ec	EXT2_ET_BAD_MAGIC,
>  	"Bad magic number in super-block"
>  
> +ec	EXT2_ET_BAD_EXT_ATTR_MAGIC,
> +	"Bad magic number in extend attribute"
> +
>  ec	EXT2_ET_REV_TOO_HIGH,
>  	"Filesystem revision too high"

Error cods MUST always be added at the end of the error code table.
Otherwise, the error code numbers will change, and that will break the
ABI --- i.e.,

#define EXT2_ET_REV_TOO_HIGH                     (2133571348L)

might turn into 

#define EXT2_ET_REV_TOO_HIGH                     (2133571349L)

and that will cause no end of confusion when older applications link
with a newer version of the libext2fs shared library.

						- Ted
