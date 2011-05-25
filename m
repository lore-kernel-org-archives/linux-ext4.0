From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 14/19] ext3: remove unnecessary dentry_unhash on
 rmdir/rename_dir
Date: Tue, 24 May 2011 20:44:49 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1105242042280.9452@cobra.newdream.net>
References: <1306267582-5347-1-git-send-email-sage@newdream.net>
 <1306267582-5347-15-git-send-email-sage@newdream.net>
 <BANLkTi=4wC9RCF+QQg0GP5bHM8X-71ckJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-51649440-1306295089=:9452"
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=4wC9RCF+QQg0GP5bHM8X-71ckJg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-51649440-1306295089=:9452
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 25 May 2011, Yongqiang Yang wrote:
> Hi,
>=20
> Which kernel version is this patch based on?
> Code in my working tree which is 2.6.39-rc3 is already same as the
> code after the patch applied.

An earlier patch in the series pushes the dentry_unhash call in fs/namei.c=
=20
down into each file system (on change in behavior).  This patch then
removes the call because it shouldn't be necessary for extN, or any other=
=20
file system that doesn't have problems with racing processes getting
references to the just-removed directory inode.

sage


>=20
> Thx!
>=20
> Yongqiang.
> On Wed, May 25, 2011 at 4:06 AM, Sage Weil <sage@newdream.net> wrote:
> > ext3 has no problems with lingering references to unlinked directory
> > inodes.
> >
> > CC: Jan Kara <jack@suse.cz>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Andreas Dilger <adilger.kernel@dilger.ca>
> > CC: linux-ext4@vger.kernel.org
> > Signed-off-by: Sage Weil <sage@newdream.net>
> > ---
> > =A0fs/ext3/namei.c | =A0 =A05 -----
> > =A01 files changed, 0 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> > index f89b1d4..32f3b86 100644
> > --- a/fs/ext3/namei.c
> > +++ b/fs/ext3/namei.c
> > @@ -2074,8 +2074,6 @@ static int ext3_rmdir (struct inode * dir, struct=
 dentry *dentry)
> > =A0 =A0 =A0 =A0struct ext3_dir_entry_2 * de;
> > =A0 =A0 =A0 =A0handle_t *handle;
> >
> > - =A0 =A0 =A0 dentry_unhash(dentry);
> > -
> > =A0 =A0 =A0 =A0/* Initialize quotas before so that eventual writes go i=
n
> > =A0 =A0 =A0 =A0 * separate transaction */
> > =A0 =A0 =A0 =A0dquot_initialize(dir);
> > @@ -2298,9 +2296,6 @@ static int ext3_rename (struct inode * old_dir, s=
truct dentry *old_dentry,
> > =A0 =A0 =A0 =A0struct ext3_dir_entry_2 * old_de, * new_de;
> > =A0 =A0 =A0 =A0int retval, flush_file =3D 0;
> >
> > - =A0 =A0 =A0 if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i=
_mode))
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry_unhash(new_dentry);
> > -
> > =A0 =A0 =A0 =A0dquot_initialize(old_dir);
> > =A0 =A0 =A0 =A0dquot_initialize(new_dir);
> >
> > --
> > 1.7.0
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> >
>=20
>=20
>=20
> --=20
> Best Wishes
> Yongqiang Yang
>=20
>=20
--557981400-51649440-1306295089=:9452--
