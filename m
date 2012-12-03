From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] ext4: remove unsafe and unnecessary memset()
Date: Mon, 3 Dec 2012 10:47:20 +0800
Message-ID: <20121203024720.GA26311@yanx>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1211301418220.8688@dhcp-1-104.brq.redhat.com>
 <alpine.LFD.2.00.1211301504160.8688@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34995 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2LCCr3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2012 21:47:29 -0500
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Mon, 3 Dec 2012 08:17:23 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 848C0125804C
	for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2012 08:17:07 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qB32lNNc23330992
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2012 08:17:24 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qB38EjVX011605
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2012 19:14:45 +1100
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1211301504160.8688@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 30, 2012 at 03:04:59PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Fri, 30 Nov 2012, Luk=C3=A1=C5=A1 Czerner wrote:
> It looks like that it has been already fixed with a different patch.
>=20
> http://www.spinics.net/lists/linux-ext4/msg35310.html
>

Hmm ... I did search this function in marc.info. Looks like I should
switch to another database. Thank you for review.

Thanks,
Guo Chao

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
