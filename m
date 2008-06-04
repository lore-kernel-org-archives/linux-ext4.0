From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Test results for ext4
Date: Wed, 04 Jun 2008 10:41:00 -0500
Message-ID: <4846B78C.3020102@redhat.com>
References: <48402253.8040407@bull.net> <4841A871.3020500@redhat.com> <4844B71F.3070906@redhat.com> <4846B5F9.8050906@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170AbYFDPlh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2008 11:41:37 -0400
In-Reply-To: <4846B5F9.8050906@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Clement wrote:
> Eric Sandeen wrote:

>> This was with e2fsprogs-1.39 for ext3, e2fsprogs-1.40.10 for ext4, a=
nd
>> xfsprogs-2.9.8 for xfs.
> I was using xfsprogs-2.9.0, maybe too old version...
> I'm updating them and I'll run my tests again.

2.9.0 is about a year old... 2.9.5 got some defaults changes for
perfomance reasons, so it might make a difference.  If kernel is
bleeding edge probably might as well use all bleeding-edge tools, too. =
 :)

=2E..

> I added a link to the scripts I used in the test description section =
in:
> http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.htm=
l
> http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2=
=2Ehtml

Great, thanks!  I think the hardware comparison is interesting...

-Eric

>    Val=E9rie

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
