From: Aditya Kali <adityakali@google.com>
Subject: Re: Ext4 quota support
Date: Mon, 4 Apr 2011 17:14:34 -0700
Message-ID: <BANLkTinzAcE=TetnzkXZ3667m=AXo4J97Q@mail.gmail.com>
References: <4D904D6B.2020201@or.uni-bonn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Christoph Bartoschek <bartoschek@or.uni-bonn.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:15833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1DEAO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Apr 2011 20:14:56 -0400
Received: from wpaz5.hot.corp.google.com (wpaz5.hot.corp.google.com [172.24.198.69])
	by smtp-out.google.com with ESMTP id p350Eug2016904
	for <linux-ext4@vger.kernel.org>; Mon, 4 Apr 2011 17:14:56 -0700
Received: from pzk10 (pzk10.prod.google.com [10.243.19.138])
	by wpaz5.hot.corp.google.com with ESMTP id p350EsWY030437
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 4 Apr 2011 17:14:55 -0700
Received: by pzk10 with SMTP id 10so2099542pzk.35
        for <linux-ext4@vger.kernel.org>; Mon, 04 Apr 2011 17:14:54 -0700 (PDT)
In-Reply-To: <4D904D6B.2020201@or.uni-bonn.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 28, 2011 at 1:57 AM, Christoph Bartoschek
<bartoschek@or.uni-bonn.de> wrote:
>
> Hi,
>
> today we had to reboot one of our fileservers with ext4. Unfortunatel=
y it decided to run a quotacheck on restart. We are now waiting till it=
 checked several TB of data.
>
> My question is: Is there a reason why the quotacheck started although=
 the server was shut down cleanly?
>
> Another question: Is the first class quota support in ext4 somthing t=
o be expected soon or should we better use another filesystem like XFS?

I have implemented the kernel changes for this, but still working on
e2fsprogs changes. I hope to get most of it working this month, but it
might not be ready to be submitted by then.

--
Aditya

>
> Christoph
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
