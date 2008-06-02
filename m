From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 6/6] delalloc ENOSPC: improve percpu	counter	accounting
 accurate
Date: Mon, 02 Jun 2008 11:45:12 +0900
Message-ID: <48435EB8.2070806@rs.jp.nec.com>
References: <1212363385.4368.69.camel@localhost.localdomain>	 <48433CAA.1050209@rs.jp.nec.com> <1212373825.4368.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:46587 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbYFBCrP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2008 22:47:15 -0400
In-Reply-To: <1212373825.4368.74.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming Cao wrote:
> On Mon, 2008-06-02 at 09:19 +0900, Akira Fujita wrote:
>> Hi,
>>
>>> Mingming Cao wrote:
>>> percpu counter: update center counter when sum per-cpu counter
>>>
>>> From: Mingming cao <cmm@us.ibm.com>
>>>
>>> Delayed allocation need to check free blocks at every write time.
>>> percpu_counter_read_positive() is not quit accurate
>>>  but using percpu_counter_sum_positive() for every write
>>> frequently is quite expensive.
>> I couldn't compile the latest ext4 patch qeueu.
>>
>>   LD      fs/ext3/ext3.o
>>   LD      fs/ext3/built-in.o
>>   CC      fs/ext4/balloc.o
>> fs/ext4/balloc.c: In function =E2=80=98ext4_has_free_blocks=E2=80=99=
:
>> fs/ext4/balloc.c:1629: error: implicit declaration of function =E2=80=
=98percpu_counter_sum_positive_set=E2=80=99
>>
>>
>>> +		    percpu_counter_sum_positive_set(&sbi->s_freeblocks_counter);
>> Maybe the above line which in percpucounter-add-sum-and-set-function=
=2Epatch
>> is percpu_counter_sum_and_set(&sbi->s_freeblocks_couter).
>>
>=20
> oops. Updated patch queue, please check again.

I confirmed that I could compile the latest ext4 patch queue correctly.
Thanks.   :-)

Regards,
Akira Fujita
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
