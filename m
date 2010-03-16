From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: Re: Using parts of ext2_fs.h in BSD licensed code
Date: Tue, 16 Mar 2010 15:34:14 +0300
Message-ID: <e1e08eb01003160534u7093df1ds4a0e3c86a0de1474@mail.gmail.com>
References: <e1e08eb01003150942s6350c04fn6b3d696fed8b7fc1@mail.gmail.com>
	 <e1e08eb01003151026q1352c02btf12d7cd6d84c3f21@mail.gmail.com>
	 <20100315182338.GG4484@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:47851 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937841Ab0CPMeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Mar 2010 08:34:17 -0400
Received: by fxm19 with SMTP id 19so4193254fxm.21
        for <linux-ext4@vger.kernel.org>; Tue, 16 Mar 2010 05:34:14 -0700 (PDT)
In-Reply-To: <20100315182338.GG4484@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 15, 2010 at 9:23 PM,  <tytso@mit.edu> wrote:
> On Mon, Mar 15, 2010 at 08:26:16PM +0300, Evgeniy Ivanov wrote:
>> Just found, that recently FreeBSD got this:
>> http://www.freebsd.org/cgi/cvsweb.cgi/src/sys/fs/ext2fs/ext2fs.h
>> It looks like I can easily include it to the BSD-licensed project an=
d
>> no GPL violation. But I dunno how did they wrote ext2fs.h, since it
>> still must be based on ext2_fs.h
>
> Constants and code points aren't subject to copyright, so they don't
> have ask any question. =A0The places where things start to get dicy i=
s
> with inline function and CPP macros, especially when the code starts
> become non-trivial. =A0i.e., there's only one way to do "(foo & MASK)=
 !=3D
> 0", so that's probably not subject to copyright. =A0A complicated 20
> line function, even if it's in a header file, is probably going to be
> subject to copyright. =A0What is and isn't a matter of copyright is
> something you'd have to get a lawyer to answer for you.
>
> You can of couse also request permission, but that can get tricky,
> especially if the person who originally wrote it can't easily be
> tracked down (I haven't talked or e-mailed with Remy in years), or if
> it was done by someone while being paid by their employer, in which
> case some corporate lawyers might have to be dragged in to give
> permission.
>
> Fortunately I don't think there's much in the way of complicated code
> in the header files that you would have to deal with.
>

Thanks a lot for your answer.

--=20
Evgeniy Ivanov
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
