From: Andrey Sidorov <qrxd43@motorola.com>
Subject: Re: A warning from 3.6+ with bigalloc and delalloc when running xfstest
Date: Sat, 13 Oct 2012 14:29:48 -0400
Message-ID: <CAA0+VHySFTOC53QGyt2aCk4vNq45dcfptEHN0vc+tLnZA0tgng@mail.gmail.com>
References: <CANWLp03Kcp75CZPr6DubSExH9GhLUqaLf=xHvLiivprs=z2BvQ@mail.gmail.com>
	<20121009054820.GA8028@thunk.org>
	<20121009062931.GA29314@gmail.com>
	<20121009135152.GA29156@thunk.org>
	<CAA0+VHwL0u0h6sn=Z0FyHsqYi2ji=sUaQ9ZPJCQ9kEMOpQHarg@mail.gmail.com>
	<20121011155708.GA9480@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Andrey Sidorov <qrxd43@motorola.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:43726 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2JMS3w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Oct 2012 14:29:52 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.176.130.20])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id q9DIWCXj027254
	for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2012 14:32:12 -0400 (EDT)
Received: from mail-vb0-f46.google.com (mail-vb0-f46.google.com [209.85.212.46])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id q9DIWBDO027236
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2012 14:32:12 -0400 (EDT)
Received: by mail-vb0-f46.google.com with SMTP id ff1so4015380vbb.19
        for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2012 11:29:49 -0700 (PDT)
In-Reply-To: <20121011155708.GA9480@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 11, 2012 at 11:57 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Hi Andrey,
>
> This warning is only triggered in a stress test case.  In our product
> system we never meet this warning, certainly we have backported bigalloc
> to 2.6.32 kernel, though.  So IMHO we needn't turn off delalloc.
>
> Regards,
> Zheng

Hi Zheng,

I didn't see it as well, but wanted to be sure it won't break file
system once occurred.
Our use-case is mostly dio and pre-fallocated writes, so I think we'll be fine.
Thanks!

Regards,
Andrey.
