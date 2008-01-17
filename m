From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Subject: Re: [PATCH] Convert EXT2 to use unlocked_ioctl
Date: Thu, 17 Jan 2008 13:26:42 +0100
Message-ID: <87abn4eiyl.fsf@barad-dur.regala.cx>
References: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx>
	<200801171254.04071.arnd@arndb.de>
	<87myr4ek82.fsf@barad-dur.regala.cx>
	<200801171318.57491.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:33952
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYAQM0o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 07:26:44 -0500
In-Reply-To: <200801171318.57491.arnd@arndb.de> (Arnd Bergmann's message of "Thu\, 17 Jan 2008 13\:18\:56 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vous m'avez dit r=E9cemment :

> On Thursday 17 January 2008, Mathieu SEGAUD wrote:
>> yep, they do. I noticed this nested calls. I guess I will add
>> _extX_compat_ioctl() running with no BKL's which would be used by bo=
th
>> extX_ioctl() and extX_compat_ioctl().
>> Any comments on such a strategy ? thanks a lot for the reminder :)
>>=20
>
> Why not just kill the lock_kernel() in extX_compat_ioctl() ?

sure, I just posted I wasn't that awake enough to see this one :)
by the way thanks for the heads up.
I repost the whole thing corrected.

--=20
Mathieu
