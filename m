From: Mark Harris <mhlk@osj.us>
Subject: Re: [PATCH] ext4: explain encoding of 34-bit a,c,mtime values
Date: Sat, 9 Nov 2013 15:51:39 -0800
Message-ID: <CADQUmxULoLgXRyoPpJJMJLqJPsZ8M4oPP8ScGxWp+Np8-efq3g@mail.gmail.com>
References: <1383808590.23882.13.camel@chiang>
	<20131107160341.GA3850@quack.suse.cz>
	<1383864864.23882.33.camel@chiang>
	<20131107231445.GG2054@quack.suse.cz>
	<1383866807.23882.41.camel@chiang>
	<D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca>
	<1383981551.8994.27.camel@chiang>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: David Turner <novalis@novalis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:61315 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab3KIXvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Nov 2013 18:51:41 -0500
Received: by mail-vb0-f49.google.com with SMTP id x11so514814vbb.8
        for <linux-ext4@vger.kernel.org>; Sat, 09 Nov 2013 15:51:39 -0800 (PST)
In-Reply-To: <1383981551.8994.27.camel@chiang>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8 November 2013 23:19, David Turner <novalis@novalis.org> wrote:
>
> On Fri, 2013-11-08 at 14:37 -0700, Andreas Dilger wrote:
> > On Nov 7, 2013, at 4:26 PM, David Turner <novalis@novalis.org> wrot=
e:
> > > On Fri, 2013-11-08 at 00:14 +0100, Jan Kara wrote:
> > >> Still unnecessary type cast here (but that's a cosmetic issue).
> > > ...
> > >> Otherwise the patch looks good. You can add:
> > >> Reviewed-by: Jan Kara <jack@suse.cz>
> > >
> > > Thanks.  A version with this correction and the reviewed-by follo=
ws.
> >
> > Thanks for working on this.  It was (seriously) in my list of thing=
s to
> > get done, but I figured I still had a few years to work on it...
> >
> > My (unfinished) version of this patch had a nice comment at ext4_en=
code_time()
> > that explained the encoding that is being used very clearly:
> >
> > /*
> >  * We need is an encoding that preserves the times for extra epoch =
"00":
> >  *
> >  * extra  msb of                         adjust for signed
> >  * epoch  32-bit                         32-bit tv_sec to
> >  * bits   time    decoded 64-bit tv_sec  64-bit tv_sec      valid t=
ime range
> >  * 0 0    1    -0x80000000..-0x00000001  0x000000000     1901-12-13=
=2E.1969-12-31
> >  * 0 0    0    0x000000000..0x07fffffff  0x000000000     1970-01-01=
=2E.2038-01-19
> >  * 0 1    1    0x080000000..0x0ffffffff  0x100000000     2038-01-19=
=2E.2106-02-07
> >  * 0 1    0    0x100000000..0x17fffffff  0x100000000     2106-02-07=
=2E.2174-02-25
> >  * 1 0    1    0x180000000..0x1ffffffff  0x200000000     2174-02-25=
=2E.2242-03-16
> >  * 1 0    0    0x200000000..0x27fffffff  0x200000000     2242-03-16=
=2E.2310-04-04
> >  * 1 1    1    0x280000000..0x2ffffffff  0x300000000     2310-04-04=
=2E.2378-04-22
> >  * 1 1    0    0x300000000..0x37fffffff  0x300000000     2378-04-22=
=2E.2446-05-10
> >  */
> >
> > It seems that your version of the patch seems to use a different en=
coding.  Not
> > that this is a problem, per-se, since my patch wasn=E2=80=99t in us=
e anywhere, but it
> > would be nice to have a similarly clear explanation of what the map=
ping is so
> > that it can be clearly understood.
>
> I have included a patch with an explanation (the patch is against
> tytso/dev -- I hope that's the correct place).
>
> > My ext4_{encode,decode}_extra_time() used add/subtract instead of m=
ask/OR ops,
> > which changed the on-disk format for times beyond 2038, but those w=
ere already
> > broken, and presumably not in use by anyone yet.
>
> They were actually correct according to my patch's encoding (that is,=
 my
> patch used the existing encoding).  The existing encoding was written
> correctly, but read wrongly.  As you say, this should not matter, sin=
ce
> nobody should be writing these timestamps, but I assumed that the
> existing encoding had happened for a reason, and wanted to make the
> minimal change.
>
> If you believe it is important, I would be happy to change it.


The problem with the existing encoding is that pre-1970 dates are
encoded with extra bits 1,1 in 64-bit kernels with ext4, but on 32-bit
kernels and inodes that were originally written as ext3 the extra bits
will be 0,0.  Currently, both are decoded as pre-1970 dates.

With your patch, only the 1,1 format used by 64-bit ext4 will decode
as a pre-1970 date.  Dates previously written by ext3 or a 32-bit
kernel will no longer be decoded as expected.  Also the patch does
not update ext4_encode_extra_time to use this format for pre-1970
dates in 32-bit mode.

Possible solutions were discussed here, but no decision was made:
http://thread.gmane.org/gmane.comp.file-systems.ext4/26087/focus=3D2640=
6


>
>
> >  However, it seemed to me this
> > was easier to produce the correct results.  Have you tested your pa=
tch with
> > a variety of timestamps to verify its correctness?
>
> I tested by using touch -d to create one file in each year between 19=
02
> and 2446.  Then I unmounted and remounted the FS, and did ls -l and
> manually verified that each file's date matched its name.
>
> > It looks to me like you
> > have mapped the 1901-1969 range onto 0x3 for the epoch bits, instea=
d
> > of the (IMHO) natural 0x0 bits. The critical time ranges are listed
> > above.
>
> I think the idea of this is that it is the bottom 34 bits of the 64-b=
it
> signed time.  However, it occurs to me that this relies on a two's
> complement machine.  Even though the C standard does not guarantee th=
is,
> I believe the kernel requires it, so that's probably OK.

 - Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
