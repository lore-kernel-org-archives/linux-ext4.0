From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Re: Re: EXT4 regression caused 4eec7
Date: Sun, 12 May 2013 17:40:31 +0400
Message-ID: <87li7kxqnk.fsf@openvz.org>
References: <31302271.2821368363898561.JavaMail.weblogic@epml17>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs\@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: eunb.song@samsung.com, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <31302271.2821368363898561.JavaMail.weblogic@epml17>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 12 May 2013 13:05:00 +0000 (GMT), EUNBONG SONG <eunb.song@samsu=
ng.com> wrote:
>=20
>=20
> >> Since at this point it's safer to rollback the change and we can
> >> investigate more deeply how to fix it correctly for the next
> >> development cycle, this is the patch which I'm testing.
>=20
> >>                     - Ted
>=20
> > Hello, I've tested with your patch. But the same problem was reprod=
uced.
> > Currently, I'm trying to git bisect. If i done git bisect, i will l=
et you know.
>=20
> Hi, I've done git bisect. and panic at jbd2_journal_put_journal_head(=
) is caused by=20
> ae4647fb7654676fc44a97e86eb35f9f06b99f66: "jbd2: reduce journal_head =
size."
OK that explains both regressions ext4/jbd2 and ext3/jbd(https://lkml.o=
rg/lkml/2013/5/10/434)
Probably some race because b_jlist accessed w/o lock some places.=20
BUT i still can not reproduce original issue :(
I've tried all types of disks near me (ssd,hdd,usb-dongle),
What disk type you use? Is it reproducible on x86?
Please post following info:
#fdisk -l  $HDD
#hdparm -t $HDD
#df -h=20
#cat /proc/mounts

> I write just code patch which revert ae4647fb7654676fc44a97e86eb35f9f=
06b99f66 because
> I don't know the root cause.=20
>=20
>=20
> Signed-off-by: Eunbong Song <eunb.song@samsung.com>
> ---
>  include/linux/journal-head.h |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/journal-head.h b/include/linux/journal-hea=
d.h
> index 13a3da2..c18b46f 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -31,14 +31,21 @@ struct journal_head {
>  	/*
>  	 * Journalling list for this buffer [jbd_lock_bh_state()]
>  	 */
> -	unsigned b_jlist:4;
> +	unsigned b_jlist;
> =20
>  	/*
>  	 * This flag signals the buffer has been modified by
>  	 * the currently running transaction
>  	 * [jbd_lock_bh_state()]
>  	 */
> -	unsigned b_modified:1;
> +	unsigned b_modified;
> +
> +	/*
> +	 * This feild tracks the last transaction id in which this buffer
> +	 * has been cowed
> +	 * [jbd_lock_bh_state()]
> +	 */
> +	tid_t b_cow_tid;
> =20
>  	/*
>  	 * Copy of the buffer data frozen for writing to the log.
> --=20
> 1.7.0.4
>=20
>=20
> Thanks. N=C2=8B=E3=8E=A0=EF=A6=9Er=C2=9By=E9=89=89=C2=9AbX=D0=A4=ED=91=
=A4v^=C2=96)=E9=A0=BB{.n+=C2=89=EB=9E=A8=C2=8A{=C2=91=E5=96=A9zX=E3=8E=8D=
=C2=9B=E2=97=8F}=C2=9E=EA=BC=BFz&j:+v=C2=89=E3=89=AD=07=C2=91=E5=96=A9z=
Z+=C2=80+zf=EF=BC=82h=C2=9A=C2=88~=C2=86=C2=86i=E9=8E=ACzw=E2=85=B1?=C2=
=99=E2=91=A1&)=E5=88=AAf=C2=94^j=ED=91=B9ym=C2=85@Aa=EB=9B=B4=7F=0C0=EB=
=9D=A0h=C2=92i=7F
