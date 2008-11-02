From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
Subject: Re: Wrong calculation of space remaining on a 32 bit system.
Date: Sun, 02 Nov 2008 23:24:31 +0100
Message-ID: <490E289F.4010907@tvcablenet.be>
References: <490DBBD9.9040300@tvcablenet.be> <20081102204352.GJ8134@mit.edu>	<490E1FB1.8020100@tvcablenet.be> <87fxm9bxps.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Graham Murray <graham@gmurray.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mirapoint3.brutele.be ([212.68.199.148]:29282 "EHLO
	mirapoint3.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYKBWYp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 17:24:45 -0500
In-Reply-To: <87fxm9bxps.fsf@newton.gmurray.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Graham Murray a =E9crit :
> "news.gmane.org" <francois.valenduc@tvcablenet.be> writes:
>=20
>> In fact, the errors I mentionned don't occur anymore. But the proble=
m of
>>   the diskspace remains. I never managed until now to use more than =
one
>> third of a partition on a 32 bit system. After that, I always get a
>> message saying that the partition is full, which can't be true.
>=20
> Just an idea, which I am sure you have already considered, but have y=
ou
> run out of inodes?=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

How can I know if I ran out of inodes ? I already tried 128 and 256
inode sizes but the problem occurs in both cases. As I said in my bug
report, I found a patch dated from november 2007 which seems to adress
the problem (see
http://osdir.com/ml/file-systems.ext4/2007-11/msg00200.htm). Off course=
,
I can't apply it any more now. But it seems this kind of problem still
exists. I have no problem to use ext4 on a 64 bit systems with logical
volumes having approximately the same size.

=46ran=E7ois

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
