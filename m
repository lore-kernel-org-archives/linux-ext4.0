From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix potential use after free in
 __ext4_journal_stop
Date: Mon, 5 Oct 2015 16:18:12 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1510051618030.4946@localhost.localdomain>
References: <1441205154-16501-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbbJEOSR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Oct 2015 10:18:17 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id E539C91EB1
	for <linux-ext4@vger.kernel.org>; Mon,  5 Oct 2015 14:18:16 +0000 (UTC)
Received: from vpn1-6-112.ams2.redhat.com (vpn1-6-112.ams2.redhat.com [10.36.6.112])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t95EICPi006089
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 5 Oct 2015 10:18:15 -0400
In-Reply-To: <1441205154-16501-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2 Sep 2015, Lukas Czerner wrote:

> Date: Wed,  2 Sep 2015 16:45:54 +0200
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-ext4@vger.kernel.org
> Cc: Lukas Czerner <lczerner@redhat.com>
> Subject: [PATCH] ext4: fix potential use after free in __ext4_journal_stop
> 
> There is a use-after-free possibility in __ext4_journal_stop() in the
> case that we free the handle in the first jbd2_journal_stop() because
> we're referencing handle->h_err afterwards. This was introduced in
> 9705acd63b125dee8b15c705216d7186daea4625 and it is wrong. Fix it by
> storing the handle->h_err value beforehand and avoid referencing
> potentially freed handle.

ping

-Lukas

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/ext4_jbd2.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index d418431..e770c1ee 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -88,13 +88,13 @@ int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle)
>  		return 0;
>  	}
>  
> +	err = handle->h_err;
>  	if (!handle->h_transaction) {
> -		err = jbd2_journal_stop(handle);
> -		return handle->h_err ? handle->h_err : err;
> +		rc = jbd2_journal_stop(handle);
> +		return err ? err : rc;
>  	}
>  
>  	sb = handle->h_transaction->t_journal->j_private;
> -	err = handle->h_err;
>  	rc = jbd2_journal_stop(handle);
>  
>  	if (!err)
> 
