From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 00/25] e2fsprogs: Misc cleanups & fixes
Date: Fri, 16 Sep 2011 16:27:46 -0500
Message-ID: <4E73BF52.4090704@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab1IPV1t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 17:27:49 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p8GLRmps006499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 16 Sep 2011 17:27:48 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p8GLRkYl031182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 16 Sep 2011 17:27:48 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/16/11 3:49 PM, Eric Sandeen wrote:
> I ran Coverity over e2fsprogs this week, hoping to find any recent-ish
> flaws, but most of what it came up with seems longstanding.  I guess
> that's a good sign for the recent work, anyway!
> 
> Some of these are just tidyups, some are bugfixes.  It gets the defect
> count down to around 25 from 70 to start with, but I'll need to take
> a deep breath before tackling the rest.

Heh, and I should have pulled from github prior to doing all this.  :(

I take back that comment about recent work, at least slightly.

Is the quota library really full of void functions which cannot return
errors?  My fault for not reviewing while it was on the list, sorry.

-Eric

> Thanks,
> -Eric
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

