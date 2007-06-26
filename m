From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: performance testing
Date: Tue, 26 Jun 2007 13:03:15 +0200
Message-ID: <4680F273.3080809@bull.net>
References: <467BE4C0.2020203@bull.net>	 <1182541578.9939.3.camel@localhost.localdomain>	 <467C99F5.6060603@clusterfs.com>	 <1182755567.4067.1.camel@localhost.localdomain> <467FE8A5.4030508@bull.net>	 <467FEAF7.7060902@clusterfs.com> <4680CE9B.1030602@bull.net>	 <4680E0FE.8080102@bull.net> <1182854211.3041.10.camel@dhcp7.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54355 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbXFZLCI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2007 07:02:08 -0400
In-Reply-To: <1182854211.3041.10.camel@dhcp7.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Girish Shilamkar wrote:
> On Tue, 2007-06-26 at 11:48 +0200, Valerie Clement wrote:
>> Shouldn't it be :
>>
>>    struct commit_header *tmp =3D (struct commit_header*)(bh->b_data =
+ i);
>>
> Ohhh, yes you are right. This is the correct thing to do.
> This patch which is been used has some endian-ness bugs. I had sent a=
n
> updated patch for 2.6.22-rc5 on=20
> 19 June. I think we should be using the updated patch else it may bre=
ak
> on big-endian machines.=20
> Even the updated patch has this bug i.e "struct commit_header *tmp
> =3D...."
>=20
> Thanks,
> Girish.
>=20
Hi Girish,
I made the change on my system and tested it. Good news, everything=20
seems to work well now. Could you please make and post the patch?
Thanks,
   Val=E9rie
