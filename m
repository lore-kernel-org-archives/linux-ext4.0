From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4  inode destroy
Date: Mon, 26 Dec 2016 11:32:38 -0700
Message-ID: <F01EC138-3B54-4666-9E8D-2D4FD106F39A@dilger.ca>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E6083C75-EEF3-4C86-B1AD-81FB11FDB7E5"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca
To: yi zhang <yi.zhang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_E6083C75-EEF3-4C86-B1AD-81FB11FDB7E5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Dec 26, 2016, at 5:34 AM, yi zhang <yi.zhang@huawei.com> wrote:
> 
> Because of the disk and hardware issue, the ext4 filesystem have
> many errors, the inode->i_nlink of ext4 becomes zero abnormally
> but the dentry is still positive, it will cause memory corruption
> after the following process:
> 
> 1) Due to the inode->i_nlink is 0, this inode will be added into
> the orhpan list,
> 2) ext4_rename() cover this inode, and drop_nlink() will reverse
> the inode->i_nlink to 0xFFFFFFFF,
> 3) iput() add this inode to LRU,
> 4) evict() will call destroy_inode() to destroy this inode but
> skip removing it from the orphan list,
> 5) after this, the inode's memory address space will be used by
> other module, when the ext4 filesystem change the orphan list, it will
> trample other module's data and then may cause oops.
> 
> Although we cannot avoid hardware and disk errors, we can control the
> softwore error in the ext4 module, do not affect other modules and
> increase the difficulty of locating problems.
> 
> This patch avoid inode->i_nlink reverse and remove the inode form the

(typo) s/form/from/

> orphan list when destroy it if the list is not empty.
> Signed-off-by: yi zhang <yi.zhang@huawei.com>
> ---
> fs/ext4/super.c | 1 +
> fs/inode.c      | 5 ++++-
> 2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 52b0530..617327e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -975,6 +975,7 @@ static void ext4_destroy_inode(struct inode *inode)
> 				EXT4_I(inode), sizeof(struct ext4_inode_info),
> 				true);
> 		dump_stack();
> +		ext4_orphan_del(NULL, inode);
> 	}
> 	call_rcu(&inode->i_rcu, ext4_i_callback);
> }
> diff --git a/fs/inode.c b/fs/inode.c
> index 88110fd..079d383 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -279,7 +279,10 @@ static void destroy_inode(struct inode *inode)
> */
> void drop_nlink(struct inode *inode)
> {
> -	WARN_ON(inode->i_nlink == 0);
> +	if (WARN(inode->i_nlink == 0, "inode %lu nlink"
> +		" is already 0", inode->i_ino))

(style) the string should be kept on a single line instead of being
split, especially since it can fit easily.

(defect) this needs to have a newline.

	if (WARN(inode->i_nlink == 0,
		 "inode %lu nlink is already 0\n", inode->i_ino))

Cheers, Andreas

> +		return;
> +
> 	inode->__i_nlink--;
> 	if (!inode->i_nlink)
> 		atomic_long_inc(&inode->i_sb->s_remove_count);
> --
> 2.5.0
> 


Cheers, Andreas






--Apple-Mail=_E6083C75-EEF3-4C86-B1AD-81FB11FDB7E5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWGFiSHKl2rkXzB/gAQhgqA/8C6HuoISklwzyl7F/h+DyMHgSL7GImoKX
QSffDSjNJbtKHvEYpu/MpiAq6ee3S3mxBmo75RNeztsVsKgziFQTwLzzv21MTdQB
pGSxJxvNsqDGONOndSoZVXjXRZvX2Im5OFm+OE3lhXPX72RauNVpqogEWLGgWqIM
3Y9ljWErfoX743EN4k/FV6+vejP4wzqz1bbtSCq2HZYNo5s6RqoNzIS5Jt0t8iq8
uwRU48tszsONjM7c/3GhlrmLldIFQOqiVDq2ayUySEdrXRlBIBntOI5ZNemzu/wA
3vatRxjywjho5nRnC7yRYoVgCaYOxFCXLBPXJje2XPNSvqIYNOfD1UZshHbDmtqc
zPA9KJhowKtBuKvXsqSQoBu9OXDSNg7wzHMAkojlFsy6G1VqRFscWCSh/+CA7g7E
xjgRlwYc0ySHXXVNH62ypxCIi+jVMt42dIzzgrKOR0gtHD/e2W4NKsDMa4UiWXQ7
keKw/8IsLRoTkVqnwiQOTh1odXQ+4eyAJnz+adUT1NnCBh26DnNKoNauYlXLDT4F
i6ZSJkD3U4cdnjy8TRpOmRp3STSmiUXDXteBO2iqaPV+wsUTZqA4v/Eaz1bFdKHZ
pjLAAUsUK9M4sCu+qp9H6k7DUgYOfMCgqqhCDc+hcS+mJvj3LOVD3rxnzqWg/FTs
7i0u9dF5Hqk=
=EJnk
-----END PGP SIGNATURE-----

--Apple-Mail=_E6083C75-EEF3-4C86-B1AD-81FB11FDB7E5--
