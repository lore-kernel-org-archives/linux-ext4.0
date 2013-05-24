From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] add generic/286 to the auto and quick groups
Date: Thu, 23 May 2013 23:54:19 -0500
Message-ID: <519EF27B.7040001@redhat.com>
References: <1369369981-7035-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab3EXEyY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 May 2013 00:54:24 -0400
In-Reply-To: <1369369981-7035-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/23/13 11:33 PM, Theodore Ts'o wrote:
> The generic/286 test tests SEEK_HOLE and SEEK_DATA, and is reasonably
> fast.  We should just run the test by default.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Seems fine to me

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

another patch to follow to fix it on kernels that don't support it.

> ---
>  tests/generic/group | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/group b/tests/generic/group
> index e2ef70e..bd443c1 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -103,7 +103,7 @@
>  277 auto ioctl quick metadata
>  280 auto quota freeze dangerous
>  285 auto rw
> -286 other
> +286 auto quick other
>  288 auto quick ioctl trim
>  294 auto quick
>  299 auto aio enospc rw stress
> 

