From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: No space left on device after many files creation
Date: Mon, 12 Apr 2010 16:28:56 -0500
Message-ID: <4BC39098.4030704@redhat.com>
References: <4BC38EB9.8080501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: cy6erGn0m <cy6ergn0m@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757Ab0DLV3C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 17:29:02 -0400
In-Reply-To: <4BC38EB9.8080501@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

cy6erGn0m wrote:
> I have found issue with ext4 partition.
> I created many many empty files with the following way:
> [cy6ergn0m@cgmachine heap]$ seq 1 10000000 | xargs touch
>=20
> But this command crashes asfter a while with a error 'no space left o=
n
> device'. At the same time, df -h shows that I have 7Gb free on this f=
ile
> system. So, I can't create any file in any directory at this filesyst=
em.
>=20
> [cy6ergn0m@cgmachine heap]$ pwd
> /e4/sandbox/heap
> [cy6ergn0m@cgmachine heap]$ ls -1 | wc -l
> 1261144
> [cy6ergn0m@cgmachine heap]$ df -h /e4
> =D0=A4=D0=B0=D0=B9=D0=BB=D0=BE=D0=B2=D0=B0=D1=8F =D1=81=D0=B8=D1=81=D1=
=82=D0=B5=D0=BC=D0=B0      =D0=A0=D0=B0=D0=B7=D0=BC  =D0=98=D1=81=D0=BF=
  =D0=94=D0=BE=D1=81=D1=82  =D0=98=D1=81=D0=BF% =D1=81=D0=BC=D0=BE=D0=BD=
=D1=82=D0=B8=D1=80=D0=BE=D0=B2=D0=B0=D0=BD=D0=B0 =D0=BD=D0=B0
> (filesystem/size/used/available/used%/mounted)
> /dev/sda4              28G  7.2G   19G  28% /e4

try df -i

There is a limited number of inodes that you can create, as set
at mkfs time.

-Eric

> [cy6ergn0m@cgmachine heap]$ touch ttt
> touch: =D0=BD=D0=B5=D0=B2=D0=BE=D0=B7=D0=BC=D0=BE=D0=B6=D0=BD=D0=BE =D0=
=B2=D1=8B=D0=BF=D0=BE=D0=BB=D0=BD=D0=B8=D1=82=D1=8C touch =D0=B4=D0=BB=D1=
=8F `ttt': =D0=9D=D0=B0 =D1=83=D1=81=D1=82=D1=80=D0=BE=D0=B9=D1=81=D1=82=
=D0=B2=D0=B5 =D0=BA=D0=BE=D0=BD=D1=87=D0=B8=D0=BB=D0=BE=D1=81=D1=8C =D0=
=BC=D0=B5=D1=81=D1=82=D0=BE
> (touch: failed to execute touch for 'ttt': No space left on device)
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
