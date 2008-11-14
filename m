From: Artem Bityutskiy <dedekind@yandex.ru>
Subject: Re: [PATCH] filesystems: use has_capability_noaudit interface for
 reserved blocks checks
Date: Fri, 14 Nov 2008 09:55:53 +0200
Message-ID: <491D2F09.3070104@yandex.ru>
References: <1226430769.3353.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org, dedekind@infradead.org,
	ext-adrian.hunter@nokia.com, linux-mtd@lists.infradead.org,
	dushistov@mail.ru, jmorris@namei.org
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:26361 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYKNIAW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 03:00:22 -0500
In-Reply-To: <1226430769.3353.5.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Paris wrote:
> ext[2,3,4], ufs, and ubifs all check for  CAP_SYS_RESOURCE to determi=
ne
> if they should allow reserved blocks to be used.  A process not havin=
g
> this capability is not failing some security decision and should not =
be
> audited.  Thus move to using has_capability_noaudit.
>=20
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---

UBIFS part looks OK, as long as the whole idea of the patch is right, w=
hich
I have not checked, but assume it is.

The only question is are you sure exporting 'cap_capable()' is relevant
to this patch? You do not seem to call it directly.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
