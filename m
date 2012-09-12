From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: remove unused function ext4_ext_check_cache
Date: Wed, 12 Sep 2012 14:17:01 -0300
Message-ID: <20120912171701.GB20409@andromeda.usersys.redhat.com>
References: <1347457961-16182-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab2ILRRF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2012 13:17:05 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8CHH5PL008555
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2012 13:17:05 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-109.phx2.redhat.com [10.3.113.109])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q8CHH1s9004290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2012 13:17:04 -0400
Content-Disposition: inline
In-Reply-To: <1347457961-16182-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 12, 2012 at 09:52:41AM -0400, Lukas Czerner wrote:
> Remove unused function ext4_ext_check_cache() and merge the code back to
> the ext4_ext_in_cache().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---

Looks good to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos
