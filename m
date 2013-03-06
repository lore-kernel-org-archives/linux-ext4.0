From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: don't assume that falloc_punch implies falloc
 in test 255
Date: Wed, 06 Mar 2013 10:10:09 -0600
Message-ID: <51376A61.6060807@redhat.com>
References: <1362506382-26974-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3CFQX5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Mar 2013 11:23:57 -0500
In-Reply-To: <1362506382-26974-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/5/13 11:59 AM, Theodore Ts'o wrote:
> As of Linux 3.9-rc1, ext4 will support the punch operation on file
> systems using indirect blocks, but it can not support the fallocate
> operation (since there is no way to mark a block as uninitialized
> using indirect block scheme).  This caused test 255 to fail, since it
> only used _require_xfS_io_falloc_punch assuming that all file systems
> which supported punch can also support fallocate.  Fix this.

Seems fine to avoid the incorrect failure, so as far as that goes:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

But we probably can & should still test punch in this situation,
so we need a new test to exercise that I guess.

-Eric

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  255 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/255 b/255
> index 0083963..ae1d8e0 100755
> --- a/255
> +++ b/255
> @@ -48,6 +48,7 @@ _supported_fs generic
>  _supported_os Linux
>  
>  _require_xfs_io_falloc_punch
> +_require_xfs_io_falloc
>  _require_xfs_io_fiemap
>  
>  testfile=$TEST_DIR/255.$$
> 

