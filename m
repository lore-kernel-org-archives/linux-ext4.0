From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] EXT4: move aio completion after unwritten extent
	conversion
Date: Mon, 28 Jun 2010 11:41:13 -0700
Message-ID: <AANLkTiknqxzwfBROKMAu5v6-059skAFGEqQIw7IIW1kr@mail.gmail.com>
References: <20100624221534.299B62008@ruihe.smo.corp.google.com>
	<20100628144956.GA21331@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, c@google.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:21411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0F1SlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jun 2010 14:41:16 -0400
In-Reply-To: <20100628144956.GA21331@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 28, 2010 at 7:49 AM, Christoph Hellwig <hch@infradead.org> =
wrote:
>
> > =A0 =A0 =A0 if (io_end->flag !=3D EXT4_IO_UNWRITTEN){
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_io_end(io_end);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 iocb->private =3D NULL;
> > - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> > +out:
> > + =A0 =A0 =A0 =A0 =A0 =A0 if (is_async)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 aio_complete(iocb, ret, 0=
);
> > + =A0 =A0 =A0 =A0 =A0 =A0 return;
>
> I'd suggest keeping the out label at the end of the function. =A0With=
out
> that the code gets unreadable very quickly.
>
I am fine with either. Having the 'out' exit label here saves us a jump=
 in the
common code path while keeping it at the end of the function comply bet=
ter
with the kernel code style. I will let Ted decide which one to take.

> > =A0 =A0 =A0 io_end->size =3D size;
> > - =A0 =A0 io_end->flag =3D EXT4_IO_UNWRITTEN;
>
> Why is this initialization removed?
>
This change is not related to the bug fix. I just realized that this
initialization seems to be unnecessary because we should already
return in the case that (io_end->flag !=3D EXT4_IO_UNWRITTEN)
at the beginning of the function.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
