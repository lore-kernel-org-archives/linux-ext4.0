From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: e2defrag 0.81 released
Date: Mon, 09 Jul 2012 14:49:51 -0400
Message-ID: <4FFB27CF.4090901@ubuntu.com>
References: <4FF76E37.1020001@ubuntu.com> <6642BE04-8D3A-4B15-8FB1-05DFB80CB6B9@dilger.ca> <4FF84D4C.1030308@ubuntu.com> <CAGpXXZ+B67C9+oxH35sW4Pjg61VC-GdJEjUqwDw57AnLHdUkAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:21139 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2GIStw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2012 14:49:52 -0400
In-Reply-To: <CAGpXXZ+B67C9+oxH35sW4Pjg61VC-GdJEjUqwDw57AnLHdUkAw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 7/9/2012 12:16 PM, Greg Freemyer wrote:
> Of course, even that is better than having to unmount the
> filesystem like you new tool apparently requires.

Old tool... very old tool ;)

I remember using the thing with one of the first releases of slackware
when I first started playing with Linux, and iirc, DOS hadn't yet
included its own defragger.

> I think you're right e4defrag userspace code ignores consolidating 
> freespace to make bigger extents possible and I don't think
> userspace has any file packing specific knowledge.
> 
> Does fallocate itself assist with either?
> 
> ie. since e4defrag uses fallocate to allocate the donor file
> blocks, logically it would make sense to add the intelligence you
> are looking for into fallocate.  And hopefully it is already
> there.

You need a method of requesting specific blocks instead of just asking
for the right number.  Then you need to analyze all of the files on
the disk to figure out where their blocks are, and decide where you
want them to be instead.  Then you could use the donor inode method to
move things around.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP+yfPAAoJEJrBOlT6nu75Y8AH/09qDUt0jdhPjNyXMUUFRVaV
U7Ih5j6r0srRHH9VmS7ppq6ingqpbrFEExbalg8ynTRX1nYDGL0nLiBU79rfK+KK
XOTK0ZYm+CUMElLdO5bYnaHti9vsSHL5xRyGmI5OR0CY7LwfnyJeDw6wS7+WsgyQ
o6ziTPcBEfaJzn9BBS+EP/1WI06lQ/cJbWUqUAJhefu2my3IXJUrjUYjnH46HKGM
2ptPbIJM2fT4QubBNnuPpdTNI5yc56+auzoB3hrK2Nf/Yh17w5R0MomHk/VitzPt
AD7zKLgpk6R9G/IbnajsMVzbLsjBbn8Tcyrhher2uyw3xE0XtJgj2fmPq32ZrL0=
=hMeu
-----END PGP SIGNATURE-----
