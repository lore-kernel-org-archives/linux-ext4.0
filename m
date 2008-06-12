From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Thu, 12 Jun 2008 19:50:35 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
 <20080611105945.GB9008@skywalker> <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de>
 <18563.1213215457@alphaville.zko.hp.com> <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
 <18513.345.553912.449710@frecb006361.adech.frec.bull.fr>
 <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu>
 <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de> <20080612180605.GD22481@skywalker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Theodore Tso <tytso@mit.edu>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:59606 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346AbYFLTun (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 15:50:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by node5.dwd.de (Postfix) with ESMTP id 46F3A3303F6
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 19:50:42 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node5.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 09896-64 for <linux-ext4@vger.kernel.org>;
	Thu, 12 Jun 2008 19:50:42 +0000 (UTC)
In-Reply-To: <20080612180605.GD22481@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 12 Jun 2008, Aneesh Kumar K.V wrote:

> On Thu, Jun 12, 2008 at 02:07:30PM +0000, Holger Kiehl wrote:
>> This time there is no OOPS and system is still up running without any
>> problem (except any process wanting to write something to this filesystem
>> gets stuck forever).
>>
>> What can I do to help find the problem? The system is still up with all those
>> process hanging in D-state.
>>
>
> if you can login to the system get the dmesg output after
>
> echo t > /proc/sysrq-trigger
>
Unfortunately I have not set CONFIG_MAGIC_SYSRQ. Tomorrow I will try to
reproduce this with a kernel that has CONFIG_MAGIC_SYSRQ set.

Holger

