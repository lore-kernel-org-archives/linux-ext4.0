From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Test results for ext4
Date: Fri, 30 May 2008 11:23:59 -0500
Message-ID: <48402A1F.8080108@redhat.com>
References: <48402253.8040407@bull.net> <484024EF.7080304@redhat.com> <4840297C.7030809@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbYE3QYv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 May 2008 12:24:51 -0400
In-Reply-To: <4840297C.7030809@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Clement wrote:
> Eric Sandeen wrote:

> Oops, I did the test on a device mapper /dev/md0. I forgot to change it in
> the test description. I will do it.
> 
> When mounting the xfs filesystem, I've got the following message:
>   Filesystem "md0": Disabling barriers, not supported by the underlying device
> 
> It means barriers are not supported by my device, isn' it?

Yep, it should be a fair fight then.  :)  I saw /dev/sde in the writeup
and figured it probably had barriers on.

Thanks,
-Eric
