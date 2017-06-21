From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v5 27/28] ext4: xattr inode deduplication
Date: Wed, 21 Jun 2017 15:14:51 -0600
Message-ID: <C5BD0B33-E343-405A-B74F-1F1717B618F9@dilger.ca>
References: <6E41DA31-A524-4E0E-BD0B-5C994399BBC6@dilger.ca>
 <20170620090721.12480-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_75547B6B-EF01-4AAD-93CD-EEA854B7D02E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170620090721.12480-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_75547B6B-EF01-4AAD-93CD-EEA854B7D02E
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jun 20, 2017, at 3:07 AM, Tahsin Erdogan <tahsin@google.com> wrote:
> 
> Ext4 now supports xattr values that are up to 64k in size (vfs limit).
> Large xattr values are stored in external inodes each one holding a
> single value. Once written the data blocks of these inodes are immutable.
> 
> The real world use cases are expected to have a lot of value duplication
> such as inherited acls etc. To reduce data duplication on disk, this patch
> implements a deduplicator that allows sharing of xattr inodes.
> 
> The deduplication is based on an in-memory hash lookup that is a best
> effort sharing scheme. When a xattr inode is read from disk (i.e.
> getxattr() call), its crc32c hash is added to a hash table. Before
> creating a new xattr inode for a value being set, the hash table is
> checked to see if an existing inode holds an identical value. If such an
> inode is found, the ref count on that inode is incremented. On value
> removal the ref count is decremented and if it reaches zero the inode is
> deleted.
> 
> The quota charging for such inodes is manually managed. Every reference
> holder is charged the full size as if there was no sharing happening.
> This is consistent with how xattr blocks are also charged.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index d79d8d7bee88..59e9488c4876 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1517,6 +1517,7 @@ struct ext4_sb_info {
> 	long s_es_nr_inode;
> 	struct ext4_es_stats s_es_stats;
> 	struct mb_cache *s_mb_cache;
> +	struct mb_cache *s_ea_inode_cache;

These names should be consistent, like "s_ea_block_cache".

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 0484df8dadd1..d7e60358ec91 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -108,6 +108,9 @@ const struct xattr_handler *ext4_xattr_handlers[] = {
> #define EXT4_GET_MB_CACHE(inode)	(((struct ext4_sb_info *) \
> 				inode->i_sb->s_fs_info)->s_mb_cache)
> 
> +#define EA_INODE_CACHE(inode)	(((struct ext4_sb_info *) \
> +				inode->i_sb->s_fs_info)->s_ea_inode_cache)

These names should be consistent, like EXT4_GET_EA_CACHE() or maybe
EXT4_GET_EA_BLOCK_CACHE() and EXT4_GET_EA_INODE_CACHE().

The rest of the changes look reasonable.

Cheers, Andreas






--Apple-Mail=_75547B6B-EF01-4AAD-93CD-EEA854B7D02E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZSuHMpIg59Q01vtYRAuTkAKC4jgj+7FLmEOHWPd4132rYRqHqBACdHu+d
9tIetJdwO+f4dFU4jwBZO0I=
=5XCG
-----END PGP SIGNATURE-----

--Apple-Mail=_75547B6B-EF01-4AAD-93CD-EEA854B7D02E--
