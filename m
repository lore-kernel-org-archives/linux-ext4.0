From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: call ext3_mark_recovery_complete() when recovery
 is really needed
Date: Thu, 3 Nov 2011 02:35:51 +0100
Message-ID: <20111103013551.GA13266@quack.suse.cz>
References: <1320113179-27491-1-git-send-email-guaneryu@gmail.com>
 <20111101224307.GF18701@quack.suse.cz>
 <CA+dCu88f-5FVBHk6-jv0X_PSJ=aS=+uRVJemS3-=p_+5FiCfmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933355Ab1KCBfx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Nov 2011 21:35:53 -0400
Content-Disposition: inline
In-Reply-To: <CA+dCu88f-5FVBHk6-jv0X_PSJ=aS=+uRVJemS3-=p_+5FiCfmA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 02-11-11 22:04:54, Eryu Guan wrote:
> On Wed, Nov 2, 2011 at 6:43 AM, Jan Kara <jack@suse.cz> wrote:
> > On Tue 01-11-11 10:06:19, Eryu Guan wrote:
> >> Call ext3_mark_recovery_complete() in ext3_fill_super() only if
> >> needs_recovery is non-zero.
> >>
> >> Besides that, print out "recovery complete" message after calling
> >> ext3_mark_recovery_complete().
> > =A0OK, I don't see a problem in this patch. But is there some benef=
it in it?
> > I'm slightly nervous it could change something subtle...
>=20
> I think current code may confuse people. The variable 'needs_recovery=
' in
> ext3_fill_super() only be used in this 'if' switch, but all the 'if'
> does is printing
> out a log message and no matter what value 'needs_recovery' is,
> ext3_mark_recovery_complete() is always being called.
>=20
> This change makes the logic more clear and of course reduce a little =
overhead
> when mounting clean fs.
>=20
> This change also consists with ext4 counter part
> 3733         if (needs_recovery) {
> 3734                 ext4_msg(sb, KERN_INFO, "recovery complete");
> 3735                 ext4_mark_recovery_complete(sb, es);
> 3736         }
  OK, consistency with ext4 makes sense. I'll take the patch. Thanks.

								Honza

> >> Cc: Jan Kara <jack@suse.cz>
> >> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> >> ---
> >> =A0fs/ext3/super.c | =A0 =A05 +++--
> >> =A01 files changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> >> index 7beb69a..2681e0d 100644
> >> --- a/fs/ext3/super.c
> >> +++ b/fs/ext3/super.c
> >> @@ -2060,9 +2060,10 @@ static int ext3_fill_super (struct super_bl=
ock *sb, void *data, int silent)
> >> =A0 =A0 =A0 EXT3_SB(sb)->s_mount_state |=3D EXT3_ORPHAN_FS;
> >> =A0 =A0 =A0 ext3_orphan_cleanup(sb, es);
> >> =A0 =A0 =A0 EXT3_SB(sb)->s_mount_state &=3D ~EXT3_ORPHAN_FS;
> >> - =A0 =A0 if (needs_recovery)
> >> + =A0 =A0 if (needs_recovery) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ext3_mark_recovery_complete(sb, es);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_msg(sb, KERN_INFO, "recovery comp=
lete");
> >> - =A0 =A0 ext3_mark_recovery_complete(sb, es);
> >> + =A0 =A0 }
> >> =A0 =A0 =A0 ext3_msg(sb, KERN_INFO, "mounted filesystem with %s da=
ta mode",
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 test_opt(sb,DATA_FLAGS) =3D=3D EXT3_MO=
UNT_JOURNAL_DATA ? "journal":
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 test_opt(sb,DATA_FLAGS) =3D=3D EXT3_MO=
UNT_ORDERED_DATA ? "ordered":
> >> --
> >> 1.7.7.1
> >>
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> >
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
