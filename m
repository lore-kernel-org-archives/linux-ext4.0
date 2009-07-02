From: Xiang Wang <xiangw@google.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Thu, 2 Jul 2009 16:27:26 -0700
Message-ID: <d5ca277e0907021627t77155cdbm4fa34bd87147d60@mail.gmail.com>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com>
	 <20090617234604.GF7867@mit.edu>
	 <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
	 <20090622211327.GI13398@webber.adilger.int>
	 <20090701183509.GB31235@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:52373 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZGBX12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jul 2009 19:27:28 -0400
Received: from wpaz5.hot.corp.google.com (wpaz5.hot.corp.google.com [172.24.198.69])
	by smtp-out.google.com with ESMTP id n62NRTRn008784
	for <linux-ext4@vger.kernel.org>; Fri, 3 Jul 2009 00:27:30 +0100
Received: from ewy20 (ewy20.prod.google.com [10.241.103.20])
	by wpaz5.hot.corp.google.com with ESMTP id n62NRQUd024411
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jul 2009 16:27:27 -0700
Received: by ewy20 with SMTP id 20so2432760ewy.3
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2009 16:27:26 -0700 (PDT)
In-Reply-To: <20090701183509.GB31235@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 1, 2009 at 11:35 AM, Aneesh Kumar
K.V<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Mon, Jun 22, 2009 at 11:13:27PM +0200, Andreas Dilger wrote:
>> On Jun 22, 2009 =A009:42 -0700, Curt Wohlgemuth wrote:
>> > I tested the locale-gen example with all combinations of
>> >
>> > =A0 =A0data=3Dwriteback
>> > =A0 =A0data=3Dordered
>> > =A0 =A0data=3Djournal
>> > =A0 =A0<no journal at all>
>>
>> On an unrelated note - would it be useful to mount an ext4 filesyste=
m
>> with a journal using "data=3Dnone" (or similar) to run without a jou=
rnal?
>>
>
> I think this is better. I would suggest data=3Dnojournal. That way we=
 can
> check the mount options to figure out whether we are running with
> journal or not. Also i guess this enables us to run without using a
> journal even if =A0mke2fs created a journal for us

We think adding this "data=3Dnojournal" mount option is a very good ide=
a.
To be more specific, after adding this option, the semantics will be:

If mke2fs does not create a journal, then we should use the
"data=3Dnojournal" mount option only.

If mke2fs creates a journal for us, we are allowed to use one of the
following 4 mount options:
data=3Dnojournal
data=3Dwriteback
data=3Dordered
data=3Djournal

We are now working on this patch and will submit it in a couple of week=
s.

Meanwhile if Ted could take the most recent patch from Curt to fix the =
data
corruption problem, that would be great!

Thanks,
Xiang

> -aneesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
