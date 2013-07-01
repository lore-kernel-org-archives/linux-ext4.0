From: Radek Pazdera <rpazdera@redhat.com>
Subject: Re: [RFC 0/9] ext4: An Auxiliary Tree for the Directory Index
Date: Mon, 1 Jul 2013 13:40:43 +0200
Message-ID: <20130701114043.GA23369@laptop.brq.redhat.com>
References: <1367702922-3236-1-git-send-email-rpazdera@redhat.com>
 <alpine.LFD.2.00.1306271123000.1781@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab3GALkp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jul 2013 07:40:45 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r61Beid6009020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 1 Jul 2013 07:40:45 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1306271123000.1781@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 27, 2013 at 11:24:19AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>On Sat, 4 May 2013, Radek Pazdera wrote:
>
>> Date: Sat,  4 May 2013 23:28:33 +0200
>> From: Radek Pazdera <rpazdera@redhat.com>
>> To: linux-ext4@vger.kernel.org
>> Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
>>     Radek Pazdera <rpazdera@redhat.com>
>> Subject: [RFC 0/9] ext4: An Auxiliary Tree for the Directory Index
>
>Hi Radek,
>
>patches do not apply cleanly any more on the ext4 dev branch. Can
>you rebase and resend the whole patch set ?

Hi Lukas,

I tried the patches with the dev branch of

    http://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/

and they seem to apply cleanly. Is that the correct tree?

This thread contains the older version of the patches, the rebased
version should be in the thread called:

    [RFC v2 0/9] ext4: An Auxiliary Tree for the Directory Index
    http://comments.gmane.org/gmane.comp.file-systems.ext4/38697

-Radek

>Thanks!
>-Lukas
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
