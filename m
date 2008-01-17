From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Subject: Re: [PATCH] Convert EXT2 to use unlocked_ioctl
Date: Thu, 17 Jan 2008 13:12:48 +0100
Message-ID: <87fxwwejlr.fsf@barad-dur.regala.cx>
References: <1200565824-362-1-git-send-email-mathieu.segaud@regala.cx>
	<200801171254.04071.arnd@arndb.de>
	<87myr4ek82.fsf@barad-dur.regala.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:60093
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYAQMMt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 07:12:49 -0500
In-Reply-To: <87myr4ek82.fsf@barad-dur.regala.cx> (Mathieu SEGAUD's message of "Thu\, 17 Jan 2008 12\:59\:25 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Vous m'avez dit r=E9cemment :

> Vous m'avez dit r=E9cemment :
>
>> On Thursday 17 January 2008, you wrote:
>>>=20
>>> Change ext_ioctl() to be an unlocked_ioctl(), explicitly
>>> exposing BKL's uses.
>>>=20
>>> Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
>>
>> You are now calling lock_kernel() twice in case of ext2_compat_ioctl=
(),
>> which calls back into ext2_ioctl with the BKL already held.
>>
>> This is allowed with the BKL, but really bad style that you should
>> avoid. I assume the ext3 and ext4dev versions of your patch have
>> the same issue, but I didn't check in detail.
>
> yep, they do. I noticed this nested calls. I guess I will add
> _extX_compat_ioctl() running with no BKL's which would be used by bot=
h
> extX_ioctl() and extX_compat_ioctl().
> Any comments on such a strategy ? thanks a lot for the reminder :)

Well as I am not awake enough, this would sum up to get rid of
lock/unlock_kernel() around extX_ioctl() calls...
Will repost with theses changes.
Thanks.

--=20
Mathieu
