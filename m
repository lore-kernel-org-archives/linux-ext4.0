From: Robin Dong <hao.bigrat@gmail.com>
Subject: [RFC] new infrastructure for manipulating different extent format
Date: Thu, 16 Feb 2012 18:51:42 +0800
Message-ID: <CAFZ0FUXAdY7CsTfC_CqPZd-hqS2C6MGEbC5oyUGMCR2-ay1g+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53344 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842Ab2BPKvn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Feb 2012 05:51:43 -0500
Received: by obcva7 with SMTP id va7so2846057obc.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Feb 2012 02:51:42 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Andreas and the list,

After the bigalloc-feature is completed in ext4, we could have much
more big size of block-group (also bigger continuous space), so larger
extent size which is above 128MB is necessary, such as:

struct ext4_extent_large {
=A0 =A0 =A0 =A0__le64 =A0ee_block; =A0 =A0 =A0 /* first logical block e=
xtent covers */
=A0 =A0 =A0 =A0__le64 =A0ee_start; =A0 =A0 =A0 /* starting physical blo=
ck */
=A0 =A0 =A0 =A0__le32 =A0ee_len; =A0 =A0 =A0 =A0 /* number of blocks co=
vered by extent */
=A0 =A0 =A0 =A0__le32 =A0ee_flags; =A0 =A0 =A0 /* flags and future exte=
nsion */
};

On the other hand, people who use ext4 in desktop environment may need
more compact format like:

struct ext4_extent_packed {
=A0 =A0 =A0 =A0__le32 =A0ee_start_lo;
=A0 =A0 =A0 =A0__le16 =A0ee_start_hi;
=A0 =A0 =A0 =A0__le16 =A0ee_len;
};

which they can fit 6 extents in the inode.

Therefore, supporting multiple extent formats is the solution which
satisfied both.

My Plan:

=46irst, abstracting the operation on disk extent format out:

struct ext4_ext_operation {
=A0 =A0 =A0 =A0 __u16 =A0 =A0 =A0 =A0 =A0 (*ext_size) (void);
 /* the size of struct ext4_extent_### */
=A0 =A0 =A0 =A0 ext4_fsblk_t =A0 =A0(*ext_pblock) (void *extent);
=A0 =A0 =A0 =A0 void =A0 =A0 =A0 =A0 =A0 =A0(*ext_store_pblock) (void *=
extent, __u64 pb);
=A0 =A0 =A0 =A0 ext4_lblk_t =A0 =A0 (*ext_lblock) (void *extent);
=A0 =A0 =A0 =A0 ext4_lblk_t =A0 =A0 (*ext_len) (void *extent);
=A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 (*is_uninit) (void *extent)=
;
=A0 =A0 =A0 =A0 void =A0 =A0 =A0 =A0 =A0 =A0(*mark_uninit) (void *exten=
t);
=A0 =A0 =A0 =A0 void =A0 =A0 =A0 =A0 =A0 =A0(*mark_init) (void *extent)=
;

=A0 =A0 =A0 =A0 __u16 =A0 =A0 =A0 =A0 =A0 (*idx_size) (void);
=A0 =A0 =A0 =A0 ext4_fsblk_t =A0 =A0(*idx_pblock) (void *idx);
=A0 =A0 =A0 =A0 void =A0 =A0 =A0 =A0 =A0 =A0(*idx_store_pblock) (void *=
idx, __u64 pb);
=A0 =A0 =A0 =A0 ext4_lblk_t =A0 =A0 (*idx_lblock) (void *idx);
};

We can use this single entry to handle different extent format through
different implementation of ext4_ext_operation (choosing different
implementation by different eh_magic number),
and the extent format which is used now could be implemented like:

static const struct ext4_ext_operation ext4_normal_eops=3D {
=A0 =A0 =A0 =A0 .ext_size =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ext4_ext_size=
,
=A0 =A0 =A0 =A0 .ext_pblock =A0 =A0 =A0 =A0 =A0 =A0 =3D ext4_ext_pblock=
,
=A0 =A0 =A0 =A0 .ext_store_pblock =A0 =A0 =A0 =3D ext4_ext_store_pblock=
,
=A0 =A0 =A0 =A0 .ext_lblock =A0 =A0 =A0 =A0 =A0 =A0 =3D ext4_ext_lblock=
,
=A0 =A0 =A0 =A0 .ext_len =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D ext4_ext_ge=
t_actual_len,
=A0 =A0 =A0 =A0 .is_uninit =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D ext4_ext_is_u=
ninitialized,
=A0 =A0 =A0 =A0 .mark_uninit =A0 =A0 =A0 =A0 =A0 =A0=3D ext4_ext_mark_u=
ninitialized,
=A0 =A0 =A0 =A0 .mark_init =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D ext4_ext_mark=
_initialized,

=A0 =A0 =A0 =A0 .idx_size =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ext4_idx_size=
,
=A0 =A0 =A0 =A0 .idx_pblock =A0 =A0 =A0 =A0 =A0 =A0 =3D ext4_idx_pblock=
,
=A0 =A0 =A0 =A0 .idx_store_pblock =A0 =A0 =A0 =3D ext4_idx_store_pblock=
,
=A0 =A0 =A0 =A0 .idx_lblock =A0 =A0 =A0 =A0 =A0 =A0 =3D ext4_idx_lblock=
,
};

=46or instance, the function ext4_ext_binsearch_idx() may look like:

static void ext4_ext_binsearch_idx(struct inode *inode,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_ext_path *p=
ath, ext4_lblk_t block)
{
=A0 =A0 =A0 =A0 struct ext4_extent_header *eh =3D path->p_hdr;
=A0 =A0 =A0 =A0 struct void *r, *l, *m;
=A0 =A0 =A0 =A0 struct ext4_ext_operation *op =3D (struct
ext4_ext_operation*)inode->private;

=A0 =A0 =A0 =A0 l =3D (char *) (eh) + sizeof(struct ext4_extent_header)=
 +
op->idx_size();
=A0 =A0 =A0 =A0 r =3D l + (le16_to_cpu(eh)->eh_entries) * op->idx_size(=
);
=A0 =A0 =A0 =A0 while (l <=3D r) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 m =3D l + op->idx_size() * ((r - l) / o=
p->idx_size())/
2;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (block < op->idx_lblock(m))
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D m - op->idx_size(=
);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 l =3D m + op->idx_size(=
);
	}
	path->p_idx =3D l - op->idx_size();
}

The only problem is the performance regression caused by frequent
function calls.

Any suggestions will be appreciated.

--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
