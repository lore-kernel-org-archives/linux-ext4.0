From: Johannes Segitz <johannes.segitz@gmail.com>
Subject: Re: fsck.ext4 taking a very long time because of "should not have
 EOFBLOCKS_FL set"
Date: Thu, 20 Oct 2011 12:58:52 +0200
Message-ID: <CAFj9jjzE_hW9sx3qAWrF+L9rufLL9rVZe_17Tqnk0WLgEiw_=Q@mail.gmail.com>
References: <CAFj9jjyLbPjehM1QbVAK9qRQ3F45sRpp055cKGa6EijWi1CBUw@mail.gmail.com>
 <20111019185344.GA4284@thunk.org> <CAFj9jjwOuukgzsgA8i3qzvEi3N7E19ugZfh3d+KGgGrrAms2OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33601 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1JTK7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 06:59:08 -0400
Received: by yxl42 with SMTP id 42so88326yxl.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2011 03:59:07 -0700 (PDT)
In-Reply-To: <CAFj9jjwOuukgzsgA8i3qzvEi3N7E19ugZfh3d+KGgGrrAms2OA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 19, 2011 at 20:53, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Oct 19, 2011 at 06:02:12PM +0200, Johannes Segitz wrote:
> What kernel version are you using, and can you upgrade to one that ha=
s
> this bug fixed? =A0This is a problem which was fixed over a year ago.=
=2E.

2.6.38-11-generic #50-Ubuntu SMP

I was running 3.0.4 until a few days ago.

I didn't fsck the filesystem for quite a while and the files on this
volume don't get
rewritten so it doesn't fix itself so i think it's just something that
was caused some
time ago and still persists

> What version of e2fsprogs are you using?

1.41.14-1ubuntu3 which seems to be the newest version

> =A0 =A0As an example use case, suppose a distribution had widely depl=
oyed a
> =A0 =A0version of the kernel where under some circumstances, the EOFB=
LOCKS_FL
> =A0 =A0flag would be left set even though it should not be left set, =
and a
> =A0 =A0customer had a workload which exercised the fencepost error al=
l the
> =A0 =A0time, resulting in many large number of inodes that had EOFBLO=
CKS_FL
> =A0 =A0set erroneously.

yeah "suppose" ;)

> =A0 =A0Leaving EOFBLOCKS_FL set when it should not be isn't a huge de=
al, and
> =A0 =A0is certainly than having high availability timeout alerts goin=
g off
> =A0 =A0left and right. =A0So in this case, the best fix might be to p=
ut the
> =A0 =A0following in /etc/e2fsck.conf:
>
> =A0 =A0[problems]
> =A0 =A00x010060 =3D { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
# PR_1_EOFBLOCKS_FL_SET
> =A0 =A0 =A0 =A0 force_no =3D true
> =A0 =A0 =A0 =A0 no_ok =3D true
> =A0 =A0 =A0 =A0 no_nomsg =3D true
> =A0 =A0}

That was pretty much what i was looking for, thank you. I'll kill fsck
tonight if it's still
running and run it again with those settings.

Thank you for your help
Johannes
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
