From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: fix possible non-initialized variable
Date: Mon, 10 Sep 2012 13:35:58 -0300
Message-ID: <20120910163558.GA11282@andromeda.usersys.redhat.com>
References: <1347108577-6239-1-git-send-email-cmaiolino@redhat.com>
 <504DFE77.6070205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab2IJQgD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2012 12:36:03 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8AGa2Ro022157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2012 12:36:02 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-109.phx2.redhat.com [10.3.113.109])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q8AGZxJo024746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2012 12:36:01 -0400
Content-Disposition: inline
In-Reply-To: <504DFE77.6070205@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I'm afraid this doesn't fix it.  So now err is init to 0, but then:
> 
>         err = ext4_map_blocks(handle, inode, &map,
>                               create ? EXT4_GET_BLOCKS_CREATE : 0);
> 
> so err is immediately reset to whatever ext4_map_blocks returns, which might be 0.
> If so, we don't go down this case:
> 
>         if (err < 0)
>                 *errp = err;
> 
> and we do go down this case,
> 
>         if (err <= 0)
>                 return NULL;
> 
> in which case we return with *errp unset.
> 
> It needs something like this, though maybe this could be made prettier/clearer.
> 
> +	*errp = 0;
>  	if (err < 0)
>  		*errp = err;
>  	if (err <= 0)
>  		return NULL;
> -	*errp = 0;

Agreed. just initializing err variable into ext4_getblk() won't ensure *errp
will be filled with 'err' content. Thanks. I'll wait for some extra inputs and
see if is there anything else people have in mind, then release a v2 patch
-- 
--Carlos
