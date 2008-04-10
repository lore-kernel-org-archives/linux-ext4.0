From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][TRIVIAL][e2fsprogs] Rename uninit_groups to uninit_bg.
Date: Thu, 10 Apr 2008 10:33:14 -0600
Message-ID: <20080410163314.GA5693@webber.adilger.int>
References: <20080402140221.30632.62083.stgit@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46926 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbYDJQhF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2008 12:37:05 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3AGb3Sk021713
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2008 09:37:03 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZ400E01AFCRD00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 10 Apr 2008 09:37:03 -0700 (PDT)
In-reply-to: <20080402140221.30632.62083.stgit@gara.konoha.net>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 02, 2008  09:03 -0500, Jose R. Santos wrote:
> Rename uninit_groups to uninit_bg.
> 
> <meta_bg> <flex_bg> <uninit_groups> <lazy_bg>
> 
> One of these things is not like the others,
> One of these things just doesn't belong,
> Can you tell which thing is not like the others
> By the time I finish my song?
>        	    by Joe Raposo

Jose,
I don't disagree with this change, but can you please keep compatibility
with the old name for some time, as we have been using the "uninit_groups"
name for some time already.

> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
> index cf37447..3fc4f91 100644
> --- a/lib/e2p/feature.c
> +++ b/lib/e2p/feature.c
> @@ -45,7 +45,7 @@ static struct feature feature_list[] = {
>  	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_HUGE_FILE,
>  			"huge_file" },
>  	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_GDT_CSUM,
> -			"uninit_groups" },
> +			"uninit_bg" },

I think we just need an additional stanza here after this one which has
the old name in it.  That way lookup-by-value will find uninit_bg, and
lookup-by-name will still work.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

