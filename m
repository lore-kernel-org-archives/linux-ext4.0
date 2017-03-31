From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Fix metadata_csum typo in ext4 man page
Date: Fri, 31 Mar 2017 08:43:26 -0700
Message-ID: <20170331154326.GA4853@birch.djwong.org>
References: <20170331142439.25698-1-jsbronder@cold-front.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Justin Bronder <jsbronder@cold-front.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44791 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933290AbdCaPne (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Mar 2017 11:43:34 -0400
Content-Disposition: inline
In-Reply-To: <20170331142439.25698-1-jsbronder@cold-front.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 31, 2017 at 10:24:39AM -0400, Justin Bronder wrote:
> Signed-off-by: Justin Bronder <jsbronder@cold-front.org>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  misc/ext4.5.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/misc/ext4.5.in b/misc/ext4.5.in
> index d7bd863..c1e67ab 100644
> --- a/misc/ext4.5.in
> +++ b/misc/ext4.5.in
> @@ -693,7 +693,7 @@ ext4, 3.6
>  ext4, 3.8
>  .IP "\fBsparse_super2\fR" 2in
>  ext4, 3.16
> -.IP "\fBmetdata_csum\fR" 2in
> +.IP "\fBmetadata_csum\fR" 2in
>  ext4, 3.18
>  .IP "\fBencrypt\fR" 2in
>  ext4, 4.1
> -- 
> 2.10.2
> 
