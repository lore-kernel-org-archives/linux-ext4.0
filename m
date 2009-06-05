From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Fri, 05 Jun 2009 14:07:59 +0300
Message-ID: <4A28FC8F.5020802@nokia.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> 	<20090603115611.6bbbaf55.akpm@linux-foundation.org> <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
Reply-To: Artem.Bityutskiy@nokia.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Denis Karpov <ext-denis.2.karpov@nokia.com>, axboe@kernel.dk,
	hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	adrian.hunter@nokia.com
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:36417 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZFELIz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 07:08:55 -0400
In-Reply-To: <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kay Sievers wrote:
> And I don't think we want several event sources for the same thing,
> uevents _and_ pollable sysfs files.
>=20
> We already raise events on /proc/self/mountinfo when the mount tree
> changes, I guess that's where fs specific stuff belongs, and it will
> work with all kind of filesystem setups, regardless of the devices
> below it. This is also the established interface for flags and option=
s
> and the current state of the filesystem, and does not mix filesystem
> options into block device interfaces.
>=20
> /proc/self/mountinfo could also work properly with namespaces which
> might have different meaning for a device in a different namespace.

Well, Denis suggests /sys/fs instead. But how would we pass stuff like
error code via /proc/self/mountinfo? And what if later some one wants
to provide user-space stuff like bogus inode number? IMO, /sys/fs
sounds better.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
