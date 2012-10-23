From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] ext4: Warn when discard request fails other than
 EOPNOTSUPP
Date: Tue, 23 Oct 2012 11:15:02 -0200
Message-ID: <20121023131502.GB14662@andromeda.usersys.redhat.com>
References: <1350648758-3318-1-git-send-email-lczerner@redhat.com>
 <1350648758-3318-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977Ab2JWNPH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Oct 2012 09:15:07 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9NDF7Xo025396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2012 09:15:07 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-84.phx2.redhat.com [10.3.113.84])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q9NDF37K007669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2012 09:15:06 -0400
Content-Disposition: inline
In-Reply-To: <1350648758-3318-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 19, 2012 at 02:12:38PM +0200, Lukas Czerner wrote:
> We should warn user then the discard request fails. However we need to
> exclude -EOPNOTSUPP case since parts of the device might not support it
> while other parts can. So print the kernel warning when the error !=
> -EOPNOTSUPP is returned from ext4_issue_discard().
> 
> We should also handle error cases in batched discard, again excluding
> EOPNOTSUPP.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/mballoc.c |   47 +++++++++++++++++++++++++++++++++++------------
>  1 files changed, 35 insertions(+), 12 deletions(-)

Looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos
