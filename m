From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] ext3: Fix data / filesystem corruption when write
 fails to copy data
Date: Wed, 9 Dec 2009 17:07:38 +0100
Message-ID: <20091209160737.GA3690@quack.suse.cz>
References: <1259781409-31318-1-git-send-email-jack@suse.cz>
 <c70ff3ad0912090742g3d35f364m11b6ae79e20893be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: saeed bishara <saeed.bishara@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756219AbZLIQK7@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c70ff3ad0912090742g3d35f364m11b6ae79e20893be@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

On Wed 09-12-09 17:42:12, saeed bishara wrote:
> I came a cross data corruption bug when using ext3, this patch fixed
> it. the bug exists in 2.6.31 and 32.
  Yes, I plan to send the fix to stable@kernel.org so that it gets fixe=
d in
the stable releases for these kernels as well. Thanks for your notice.

									Honza

> On Wed, Dec 2, 2009 at 9:16 PM, Jan Kara <jack@suse.cz> wrote:
> > When ext3_write_begin fails after allocating some blocks or
> > generic_perform_write fails to copy data to write, we truncate bloc=
ks already
> > instantiated beyond i_size. Although these blocks were never inside=
 i_size, we
> > have to truncate pagecache of these blocks so that corresponding bu=
ffers get
> > unmapped. Otherwise subsequent __block_prepare_write (called becaus=
e we are
> > retrying the write) will find the buffers mapped, not call ->get_bl=
ock, and
> > thus the page will be backed by already freed blocks leading to fil=
esystem and
> > data corruption.
> >
> > CC: linux-ext4@vger.kernel.org
> > Reported-by: James Y Knight <foom@fuhm.net>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> > =A0fs/ext3/inode.c | =A0 18 ++++++++++++++----
> > =A01 files changed, 14 insertions(+), 4 deletions(-)
> >
> > I will take care of merging this patch. I'm just sending it for com=
pleteness...
> >
> > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > index 354ed3b..f9d6937 100644
> > --- a/fs/ext3/inode.c
> > +++ b/fs/ext3/inode.c
> > @@ -1151,6 +1151,16 @@ static int do_journal_get_write_access(handl=
e_t *handle,
> > =A0 =A0 =A0 =A0return ext3_journal_get_write_access(handle, bh);
> > =A0}
> >
> > +/*
> > + * Truncate blocks that were not used by write. We have to truncat=
e the
> > + * pagecache as well so that corresponding buffers get properly un=
mapped.
> > + */
> > +static void ext3_truncate_failed_write(struct inode *inode)
> > +{
> > + =A0 =A0 =A0 truncate_inode_pages(inode->i_mapping, inode->i_size)=
;
> > + =A0 =A0 =A0 ext3_truncate(inode);
> > +}
> > +
> > =A0static int ext3_write_begin(struct file *file, struct address_sp=
ace *mapping,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0loff=
_t pos, unsigned len, unsigned flags,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stru=
ct page **pagep, void **fsdata)
> > @@ -1209,7 +1219,7 @@ write_begin_failed:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unlock_page(page);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page_cache_release(page);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (pos + len > inode->i_size)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_truncate(inode);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_truncate_failed_=
write(inode);
> > =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0if (ret =3D=3D -ENOSPC && ext3_should_retry_alloc(in=
ode->i_sb, &retries))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto retry;
> > @@ -1304,7 +1314,7 @@ static int ext3_ordered_write_end(struct file=
 *file,
> > =A0 =A0 =A0 =A0page_cache_release(page);
> >
> > =A0 =A0 =A0 =A0if (pos + len > inode->i_size)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_truncate(inode);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_truncate_failed_write(inode);
> > =A0 =A0 =A0 =A0return ret ? ret : copied;
> > =A0}
> >
> > @@ -1330,7 +1340,7 @@ static int ext3_writeback_write_end(struct fi=
le *file,
> > =A0 =A0 =A0 =A0page_cache_release(page);
> >
> > =A0 =A0 =A0 =A0if (pos + len > inode->i_size)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_truncate(inode);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_truncate_failed_write(inode);
> > =A0 =A0 =A0 =A0return ret ? ret : copied;
> > =A0}
> >
> > @@ -1383,7 +1393,7 @@ static int ext3_journalled_write_end(struct f=
ile *file,
> > =A0 =A0 =A0 =A0page_cache_release(page);
> >
> > =A0 =A0 =A0 =A0if (pos + len > inode->i_size)
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_truncate(inode);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_truncate_failed_write(inode);
> > =A0 =A0 =A0 =A0return ret ? ret : copied;
> > =A0}
> >
> > --
> > 1.6.4.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ker=
nel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> > Please read the FAQ at =A0http://www.tux.org/lkml/
> >
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
