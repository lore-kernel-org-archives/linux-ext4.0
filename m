From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Fri, 9 Dec 2016 13:28:05 -0700
Message-ID: <7A0D8B8E-7D71-4281-A7F5-65836412DBDE@dilger.ca>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net> <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca> <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net> <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca> <53212988-1445-45A4-B56F-0F240013B64C@dilger.ca> <8760mv4mhi.fsf@turtle.gmx.de> <20161209012521.GM4326@dastard>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_204FFDEB-4B6C-48F8-BEE9-796086C237A0"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Renaud Mariana <rmariana@online.net>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        debian-dpkg@lists.debian.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35412 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbcLIU2P (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Dec 2016 15:28:15 -0500
Received: by mail-io0-f195.google.com with SMTP id f73so9161503ioe.2
        for <linux-ext4@vger.kernel.org>; Fri, 09 Dec 2016 12:28:15 -0800 (PST)
In-Reply-To: <20161209012521.GM4326@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_204FFDEB-4B6C-48F8-BEE9-796086C237A0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 8, 2016, at 6:25 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Wed, Dec 07, 2016 at 07:34:17PM +0100, Sven Joachim wrote:
>> On 2016-12-07 11:16 -0700, Andreas Dilger wrote:
>>=20
>>> Add debian-dpkg mailing list to CC.
>>>=20
>>> On Dec 7, 2016, at 10:58 AM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>>>>=20
>>>> On Dec 7, 2016, at 2:52 AM, Renaud Mariana <rmariana@online.net> =
wrote:
>>>>>=20
>>>>> Here are my answers, hope it will help solve this issue, thanks.
>>>>>=20
>>>>> Recap:
>>>>> dpkg kibana on ext4 over a nbd device takes 10 minutes
>>>>> with xfs it's only 30s.
>>>>> with ext4 no extends only 30s.
>>>>>=20
>>>>>=20
>>>>> kernels :
>>>>> 4.5.7 has this issue as older kernel like 4.4.34
>>>>> The issue is also when nbd client & server run on same host
>>>>>=20
>>>>>=20
>>>>> How small are the files?
>>>>> here is the histogram of file sizes : =
http://pasteboard.co/6HC3nKyk2.png
>>>>> We can see 5000 files around 512 Bytes.
>>>>=20
>>>> Definitely there is no value to use fallocate for 512-byte files, =
or any
>>>> of the files that can be written in a single write() syscall.  I'd =
expect
>>>> any reasonable tool to be using a write buffer of at least 2-4MB =
these
>>>> days to get good performance, so writes below the buffer size =
shouldn't
>>>> use fallocate() at all.
>>=20
>> It should be noted that the latest dpkg (1.18.15) only uses fallocate
>> for files which are at least 16 KiB in size[1], so it would be nice =
if
>> Renaud could recheck with that version, or cherry-pick the patch into
>> whatever version he uses.
>=20
> The fallocate() call should be removed completely. Applications
> should not be attempting to control file allocation like this as it
> defeats all the optimisations that filesystems use to optimise IO
> patterns and minimise filesystem fragmentation (e.g. delayed
> allocation).
>=20
> There is /rarely/ a need for applications to use fallocate() to
> manage fragmentation - especailly as excessive use of fallocate()
> actively harms performance and accelerates filesystem aging.
>=20
> Unless an application has a specific, repeatable performance problem
> due to file fragmentation, it should not be using fallocate() to
> allocate file space.

I'm not sure I'd go so far as to say that fallocate() should be removed
completely.  Isn't that the best (only) way for an application to tell
the filesystem that it is about to write a file of X size and try to
find a suitable amount of free space for it?  Otherwise, if the file
is large and/or written slowly and/or the system has memory pressure
the filesystem (even with delalloc) can't make a good decision about
allocation.  However, fallocate() won't really help if the file size
is small (e.g. a few MB) since that can easily fit into RAM and will
be written to disk in a single chunk.

Cheers, Andreas






--Apple-Mail=_204FFDEB-4B6C-48F8-BEE9-796086C237A0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWEsT13Kl2rkXzB/gAQhUKRAAuYZwpOLK41NnBrT6ZS2r/mp7lVrDN3ZG
x+SARByhmFoJ5H0JBChIa5YTJbaEh2IzU3QaFFSM8wTRq8TVq5ZMGRDewtePjKIk
TnVXo7jg/ryy7gjJL+zRakcGSj0N7Xnw1dVEhJHFtVj5+LcsMjD8EqXXTM7D/rdJ
+XA0msxVDwvFfvISuMpNt0g0XaarDWY5Wj9S4KKyGVB6dgJdNgtCq1LqVpizKcB0
32oYs21hQVVhOe4dEHBa+hxGIh/IRczxNbpeVdhxvUOIuMj5959Kua8ROxape/sq
AFnSyBd8BKGkhZ8D6ghCwldV81gqNbTC3ckfyZe5oUN+PRRPLGte8DulIypcsShu
xpzEuZBTN8LubgdwJ/CJIIVqd7h63Xfm8aA+MsmfEK5yIkjkWXTeqJBsNRW692YB
5a+zuC+eyaLW6PsP6yWVNWy8ktG7vAG6cM6/KO+o7ejezjkt9qZm5sPAX27YM3Lg
Jd1DJm3HKSi5ASKAoqHarhwKtpXoYDg4Vvto1vGQra5IXusiVVJ1CAuAM4QwGhIX
jtBQ19jryCNDAUqXjVZHbtbVt0H/zvjVnYhScszbSt6L2O1XoBig6k1uzVAUK99i
e6bCP5IJMRLe4stJlqvYlYChNYznf2xR9z1zssvERegxi7vfwbzxrZO7yDpu8SJP
kSdg1Qoh74I=
=Ue9m
-----END PGP SIGNATURE-----

--Apple-Mail=_204FFDEB-4B6C-48F8-BEE9-796086C237A0--
