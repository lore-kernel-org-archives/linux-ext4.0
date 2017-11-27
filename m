From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] generic/458: document the fix commit
Date: Mon, 27 Nov 2017 08:47:49 -0800
Message-ID: <20171127164749.GA19370@magnolia>
References: <1511419423-7905-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eryu Guan <eguan@redhat.com>,
        Josef Bacik <jbacik@fb.com>, fstests@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31224 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752777AbdK0Qr7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Nov 2017 11:47:59 -0500
Content-Disposition: inline
In-Reply-To: <1511419423-7905-1-git-send-email-amir73il@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 23, 2017 at 08:43:42AM +0200, Amir Goldstein wrote:
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  tests/generic/458 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/generic/458 b/tests/generic/458
> index 7b408cb..730561f 100755
> --- a/tests/generic/458
> +++ b/tests/generic/458
> @@ -4,6 +4,9 @@
>  # Regression test for xfs leftover CoW extents after truncate
>  # and umount
>  #
> +# Fixed by commit 3af423b03435 ("xfs: evict CoW fork extents when performing
> +# finsert/fcollapse")
> +#
>  #-----------------------------------------------------------------------
>  # Copyright (C) 2017 CTERA Networks. All Rights Reserved.
>  # Author: Amir Goldstein <amir73il@gmail.com>
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
