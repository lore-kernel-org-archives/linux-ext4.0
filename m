From: Amir Goldstein <amir73il@gmail.com>
Subject: xfstests: failure to umount ext4
Date: Wed, 23 Mar 2011 16:36:17 +0200
Message-ID: <AANLkTi=NKxmvJx_oEpdeMtfU9ePv4ofG5PjCuh23RJ+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: XFS <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35633 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab1CWOgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2011 10:36:18 -0400
Received: by qyg14 with SMTP id 14so7118926qyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Mar 2011 07:36:17 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 23, 2011 at 4:03 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
>
> I've been running xfstests on ext4 and I always get annoying failures=
 to umount:
>
> 213 8s ... 31s
> umount: /mnt/test/ext4: device is busy.
> =A0 =A0 =A0 =A0(In some cases useful info about processes that use
> =A0 =A0 =A0 =A0 the device is found by lsof(8) or fuser(1))
>
> post 198 mostly fails to umount as well.
> and post 124 always fails to umount.
>
> My server is Ubuntu 10.10, running kernel 2.6.38.
>
> Is there any known issue about this? because I could find it on googl=
e
> or on the XFS list.
>

Hi All,

Has anyone seen these failures when running xfstests on ext4?
My test and scratch partitions are dedicated for xfstests.

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
