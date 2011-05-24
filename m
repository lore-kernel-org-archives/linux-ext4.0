From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: xfsprogs: Fix for xfstest 252 hang on ext4
Date: Tue, 24 May 2011 09:16:24 +0800
Message-ID: <BANLkTiks0NSDTSPN8n446JHWhKtM61_=Mw@mail.gmail.com>
References: <4DDAC4EF.1050702@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xfs-oss <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55080 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab1EXBQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 21:16:25 -0400
Received: by vws1 with SMTP id 1so4582648vws.19
        for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 18:16:24 -0700 (PDT)
In-Reply-To: <4DDAC4EF.1050702@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 24, 2011 at 4:34 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> Hi all,
>
> While trying to add more punch hole tests to xfstest, I found that te=
st 252 hangs on ext4 due to a loop in xfsprogs that does not exit. =A0X=
=46S gets out of this loop because there is logic in the loop that look=
s for the last extent flag and breaks out. =A0But it looks like ext4 do=
es not return a last extent when the file has a hole at the end. =A0I a=
m not sure if this is the correct behavior or not, so I will copy the e=
xt4 folks on this too. =A0Below is a copy of the fix for xfsprogs:

Hi there,

What's blocksize of the tested ext4?    For now, ext4 returns
LAST_EXTENT if the logical offset covered by the extent is greater
than file size, so if there is a hole at the end, no last extent is
returned. Thx!

Yongqiang.

>
> diff --git a/io/fiemap.c b/io/fiemap.c
> index fa990cc..81fc92c 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -246,7 +246,7 @@ fiemap_f(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flg_w, _("FLAGS"));
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 while (!last && ((cur_extent + 1) !=3D max_extents)) {
> + =A0 =A0 =A0 while (!last && (cur_extent <=3D max_extents)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (max_extents)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_extents =3D min(nu=
m_extents,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0max_extents - (cur_extent + 1));
>
>
> It looks like the loop enters with last=3D0, cur_extents=3D0, and max=
_extents =3D 0, and on the first iteration cur_extents get set to 2, so=
 we dont see ((cur_extent + 1) =3D=3D max_extents for a very long time.=
 =A0I doubt the logic was meant to work that way, so this patch should =
fix it, but I wanted to make sure that the fiemap for ext4 is working a=
s intended too. =A0Feed back appreciated! =A0Thx all!
>
> Allison Henderson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
