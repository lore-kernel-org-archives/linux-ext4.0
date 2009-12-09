From: saeed bishara <saeed.bishara@gmail.com>
Subject: Re: [PATCH 1/3] ext3: Fix data / filesystem corruption when write
	fails to copy data
Date: Wed, 9 Dec 2009 17:42:12 +0200
Message-ID: <c70ff3ad0912090742g3d35f364m11b6ae79e20893be@mail.gmail.com>
References: <1259781409-31318-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752817AbZLIPmJ@vger.kernel.org>
In-Reply-To: <1259781409-31318-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
I came a cross data corruption bug when using ext3, this patch fixed
it. the bug exists in 2.6.31 and 32.
saeed


On Wed, Dec 2, 2009 at 9:16 PM, Jan Kara <jack@suse.cz> wrote:
> When ext3_write_begin fails after allocating some blocks or
> generic_perform_write fails to copy data to write, we truncate blocks=
 already
> instantiated beyond i_size. Although these blocks were never inside i=
_size, we
> have to truncate pagecache of these blocks so that corresponding buff=
ers get
> unmapped. Otherwise subsequent __block_prepare_write (called because =
we are
> retrying the write) will find the buffers mapped, not call ->get_bloc=
k, and
> thus the page will be backed by already freed blocks leading to files=
ystem and
> data corruption.
>
> CC: linux-ext4@vger.kernel.org
> Reported-by: James Y Knight <foom@fuhm.net>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> =C2=A0fs/ext3/inode.c | =C2=A0 18 ++++++++++++++----
> =C2=A01 files changed, 14 insertions(+), 4 deletions(-)
>
> I will take care of merging this patch. I'm just sending it for compl=
eteness...
>
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 354ed3b..f9d6937 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1151,6 +1151,16 @@ static int do_journal_get_write_access(handle_=
t *handle,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ext3_journal_get_write_access(handl=
e, bh);
> =C2=A0}
>
> +/*
> + * Truncate blocks that were not used by write. We have to truncate =
the
> + * pagecache as well so that corresponding buffers get properly unma=
pped.
> + */
> +static void ext3_truncate_failed_write(struct inode *inode)
> +{
> + =C2=A0 =C2=A0 =C2=A0 truncate_inode_pages(inode->i_mapping, inode->=
i_size);
> + =C2=A0 =C2=A0 =C2=A0 ext3_truncate(inode);
> +}
> +
> =C2=A0static int ext3_write_begin(struct file *file, struct address_s=
pace *mapping,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loff_t pos, unsigned len, uns=
igned flags,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct page **pagep, void **f=
sdata)
> @@ -1209,7 +1219,7 @@ write_begin_failed:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unlock_page(pa=
ge);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0page_cache_rel=
ease(page);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pos + len =
> inode->i_size)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ext3_truncate(inode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ext3_truncate_failed_write(inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret =3D=3D -ENOSPC && ext3_should_retr=
y_alloc(inode->i_sb, &retries))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto retry;
> @@ -1304,7 +1314,7 @@ static int ext3_ordered_write_end(struct file *=
file,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0page_cache_release(page);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pos + len > inode->i_size)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext3_truncate(inod=
e);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext3_truncate_fail=
ed_write(inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret ? ret : copied;
> =C2=A0}
>
> @@ -1330,7 +1340,7 @@ static int ext3_writeback_write_end(struct file=
 *file,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0page_cache_release(page);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pos + len > inode->i_size)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext3_truncate(inod=
e);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext3_truncate_fail=
ed_write(inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret ? ret : copied;
> =C2=A0}
>
> @@ -1383,7 +1393,7 @@ static int ext3_journalled_write_end(struct fil=
e *file,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0page_cache_release(page);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pos + len > inode->i_size)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext3_truncate(inod=
e);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext3_truncate_fail=
ed_write(inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret ? ret : copied;
> =C2=A0}
>
> --
> 1.6.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>
