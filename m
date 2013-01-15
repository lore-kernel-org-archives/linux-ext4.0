From: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
Subject: Re: [PATCH] lib/ext2fs/bitops.h: Use the optmized/documented byteswapping
 routines
Date: Mon, 14 Jan 2013 22:07:18 -0300
Message-ID: <50F4ABC6.6080001@opensuse.org>
References: <1358019145-2774-1-git-send-email-crrodriguez@opensuse.org> <20130114141356.GA12052@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ye0-f170.google.com ([209.85.213.170]:49682 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab3AOBI0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2013 20:08:26 -0500
Received: by mail-ye0-f170.google.com with SMTP id m12so777154yen.29
        for <linux-ext4@vger.kernel.org>; Mon, 14 Jan 2013 17:08:25 -0800 (PST)
In-Reply-To: <20130114141356.GA12052@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/14/2013 11:13 AM, Theodore Ts'o wrote:
> On Sat, Jan 12, 2013 at 04:32:25PM -0300, Cristian Rodr=EDguez wrote:
>> In x86, it will not make much difference but other targets that
>> are not covered by the old code will be able to generate better code=
=2E
>>
>> Signed-off-by: Cristian Rodr=EDguez <crrodriguez@opensuse.org>
>
> The problem is that bswap_{16,32,64}() and the existence of
> <byteswap.h> is not guaranted by any standard that I'm not aware of.
> A quick Google search indicates that it's not available for the
> following platforms:
>
> 	* Mac OS X 10.5
> 	* FreeBSD 6.0
> 	* NetBSD 5.0
> 	* OpenBSD 3.8
> 	* Minix 3.1.8
> 	* AIX 5.1
> 	* HP-UX 11
> 	* IRIX 6.5
> 	* OSF/1 5.1
> 	* Solaris 11 2011-11
> 	* Cygwin
> 	* mingw
> 	* MSVC 9
> 	* Interix 3.5
> 	* BeOS
>
> So the only way we could use bswap_{16,32,64} if there is a proper
> configure.in test for them.

The code does not compile anyway at least in mingw (I just tried) and=20
probably in several other targets anyway.. with or without my patch :-)

I wonder *where* the developers of this other systems are and if they=20
are willing to submit any improvement or fixes for the software.



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
