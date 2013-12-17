From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 26/74] libss: fix memory handling errors
Date: Tue, 17 Dec 2013 11:04:15 -0600
Message-ID: <52B0840F.40407@redhat.com>
References: <20131211011813.30655.39624.stgit@birch.djwong.org> <20131211012115.30655.51030.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab3LQREV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Dec 2013 12:04:21 -0500
In-Reply-To: <20131211012115.30655.51030.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/10/13, 7:21 PM, Darrick J. Wong wrote:
> Fix memory allocation calculations and check for NULL pointer returns.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ss/invocation.c  |    5 +++++
>  lib/ss/parse.c       |    4 ++++
>  lib/ss/request_tbl.c |    2 +-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/lib/ss/invocation.c b/lib/ss/invocation.c
> index a711050..08b66f2 100644
> --- a/lib/ss/invocation.c
> +++ b/lib/ss/invocation.c
> @@ -20,6 +20,7 @@
>  #ifdef HAVE_DLOPEN
>  #include <dlfcn.h>
>  #endif
> +#include <errno.h>
>  
>  int ss_create_invocation(subsystem_name, version_string, info_ptr,
>  			 request_table_ptr, code_ptr)
> @@ -46,6 +47,10 @@ int ss_create_invocation(subsystem_name, version_string, info_ptr,
>  		;
>  	table = (ss_data **) realloc((char *)table,
>  				     ((unsigned)sci_idx+2)*size);
> +	if (table == NULL) {
> +		*code_ptr = errno;
> +		return 0;
> +	}

According to coverity CID 295143, this leaks "new_table"

Just a free() before return would suffice I think.

Thanks,
-Eric

