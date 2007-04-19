From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Performance degradation with FFSB between 2.6.20 and 2.6.21-rc7
Date: Thu, 19 Apr 2007 14:45:02 +0200
Message-ID: <4627644E.7010002@bull.net>
References: <462622F8.10107@bull.net> <20070419090346.GE20928@kernel.dk> <462736FC.3090902@bull.net> <20070419115840.GA11780@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46873 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S637744AbXDSMpv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Apr 2007 08:45:51 -0400
In-Reply-To: <20070419115840.GA11780@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jens Axboe wrote:
> On Thu, Apr 19 2007, Valerie Clement wrote:
>> Jens Axboe wrote:
>>> Please tell me how you are running ffsb, and also please include a
>>> dmessg from a booted system.
>>>
>> Hi,
>> our mails crossed! please see my response to Andrew.
>> You could reproduce the problem with dd command as suggested, it's m=
ore=20
>> easy.
>> I'm sending you the dmesg info. For my tests I used the scsci sdc de=
vice.
>=20
> Thanks, it does. Can you try one thing for me? If you run the test on
> sdc, try doing:
>=20
> # echo 64 > /sys/block/sdc/queue/iosched/quantum
>=20
> and repeat the test.
>=20

OK, that's done.

With the change of quantum, the throughput scores are now a little bit=20
better in 2.6.21 than in 2.6.20.

   Val=E9rie
