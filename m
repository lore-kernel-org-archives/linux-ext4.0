From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libe2p: Add JFS_FEATURE_INCOMPAT_64BIT parsing
Date: Thu, 24 May 2012 12:30:05 -0500
Message-ID: <4FBE701D.2000402@redhat.com>
References: <4FBE6EE1.2000000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab2EXRaH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 May 2012 13:30:07 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4OHU7PQ003863
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 13:30:07 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4OHU5hX016393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2012 13:30:06 -0400
In-Reply-To: <4FBE6EE1.2000000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/24/12 12:24 PM, Eric Sandeen wrote:
> Today, dumpe2fs for example will give this for a
> journal with JFS_FEATURE_INCOMPAT_64BIT:
> 
> Journal features:         FEATURE_I1
> 
> So fix this to show the more useful:
> 
> Journal features:         journal_64bit
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Oh, I see that this already got committed into the maint branch.

Nevermind.

> ---
> 
> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
> index db85365..9691263 100644
> --- a/lib/e2p/feature.c
> +++ b/lib/e2p/feature.c
> @@ -104,6 +104,8 @@ static struct feature jrnl_feature_list[] = {
>  
>         {       E2P_FEATURE_INCOMPAT, JFS_FEATURE_INCOMPAT_REVOKE,
>                         "journal_incompat_revoke" },
> +       {       E2P_FEATURE_INCOMPAT, JFS_FEATURE_INCOMPAT_64BIT,
> +                       "journal_64bit" },
>         {       E2P_FEATURE_INCOMPAT, JFS_FEATURE_INCOMPAT_ASYNC_COMMIT,
>                         "journal_async_commit" },
>         {       0, 0, 0 },
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

