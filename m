From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/7] ext2: Avoid DAX zeroing to corrupt data
Date: Tue, 17 May 2016 09:19:50 +0200
Message-ID: <20160517071950.GA31991@quack2.suse.cz>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
 <1462960733-29634-4-git-send-email-jack@suse.cz>
 <20160512184522.GA19851@linux.intel.com>
 <20160516152206.GC21714@quack2.suse.cz>
 <1463467967.3069.3.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463467967.3069.3.camel@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 17-05-16 06:52:47, Verma, Vishal L wrote:
> On Mon, 2016-05-16 at 17:22 +0200, Jan Kara wrote:
> > On Thu 12-05-16 12:45:22, Ross Zwisler wrote:
> > >=20
> > > On Wed, May 11, 2016 at 11:58:49AM +0200, Jan Kara wrote:
> > > >=20
> > > > Currently ext2 zeroes any data blocks allocated for DAX inode
> > > > however it
> > > > still returns them as BH_New. Thus DAX code zeroes them again i=
n
> > > > dax_insert_mapping() which can possibly overwrite the data that
> > > > has been
> > > > already stored to those blocks by a racing dax_io(). Avoid
> > > > marking
> > > > pre-zeroed buffers as new.
> > > >=20
> > > > Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > > ---
> > > > =A0fs/ext2/inode.c | 4 ++--
> > > > =A01 file changed, 2 insertions(+), 2 deletions(-)
> > > >=20
> > > > diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> > > > index 6bd58e6ff038..1f07b758b968 100644
> > > > --- a/fs/ext2/inode.c
> > > > +++ b/fs/ext2/inode.c
> > > > @@ -745,11 +745,11 @@ static int ext2_get_blocks(struct inode
> > > > *inode,
> > > > =A0			mutex_unlock(&ei->truncate_mutex);
> > > > =A0			goto cleanup;
> > > > =A0		}
> > > > -	}
> > > > +	} else
> > > > +		set_buffer_new(bh_result);
> > > > =A0
> > > > =A0	ext2_splice_branch(inode, iblock, partial,
> > > > indirect_blks, count);
> > > > =A0	mutex_unlock(&ei->truncate_mutex);
> > > > -	set_buffer_new(bh_result);
> > > > =A0got_it:
> > > > =A0	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-
> > > > 1].key));
> > > > =A0	if (count > blocks_to_boundary)
> > > > --=A0
> > > > 2.6.6
> > > Interestingly this change is causing a bunch of xfstests
> > > regressions for me
> > > with ext2 + DAX.=A0=A0All of these tests pass without this one ch=
ange.
> > Good catch. Attached patch fixes this issue for me. Preferably it
> > should be
> > merged before the above ext2 change.
> >=20
> > 								Honza
>=20
> Hey Jan,
>=20
> In my patch 3 of the error handling series, I have:
>=20
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err =3D dax_clear_secto=
rs(inode->i_sb->s_bdev,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0le32_to_cpu(chain[depth-1].key) <<
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0(inode->i_blkbits - 9),
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A01 << inode->i_blkbits);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err =3D sb_issue_zeroou=
t(inode->i_sb,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0le32_to_cpu(chain[depth-1].key), 1, GFP_NOFS);
>=20
> Does this mean I have to change to send the sb_issue_zeroout for
> 'count' blocks.. i.e.

Yes, I've noticed the conflict today as well.

> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err =3D dax_clear_secto=
rs(inode->i_sb->s_bdev,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0le32_to_cpu(chain[depth-1].key) <<
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0(inode->i_blkbits - 9),
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A01 << inode->i_blkbits);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err =3D sb_issue_zeroou=
t(inode->i_sb,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0le32_to_cpu(chain[depth-1].key), count, GFP_NOF=
S);
>=20
> If so, I'll update my series tomorrow to include in both of these cha=
nges.

I'd prefer these two to stay separate commits (they are really
independent).  Since you already depend on other patches from the DAX
cleanup series, just add this patch to the list of dependencies and bas=
e
your change on that... Hmm?

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
