From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Wed, 13 Dec 2006 15:08:37 +0100
Message-ID: <45800965.2080005@bull.net>
References: <m3vekwtqnp.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42551 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964973AbWLMOjw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 09:39:52 -0500
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3vekwtqnp.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:

> +/*
> + * entry function for inode syncing
> + * it's responsbility is to sort all inode out in their locality gro=
ups
> + */
> +void ext4_lg_sync_inodes(struct super_block *sb, struct writeback_co=
ntrol *wbc)
> +{
> +	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +	struct ext4_locality_group *lg;
> +
> +	/* refill pending groups from s_dirty */
> +	spin_lock(&inode_lock);
> +	while (!list_empty(&sb->s_dirty)) {
> +		struct inode *inode =3D list_entry(sb->s_dirty.prev,
> +						struct inode, i_list);
> +		struct ext4_inode_info *ei =3D EXT4_I(inode);
> +
> +		lg =3D ei->i_locality_group;
> +		if (lg =3D=3D NULL) {
> +			if (S_ISDIR(inode->i_mode) || i_size_read(inode) =3D=3D 0) {
> +				if (atomic_read(&inode->i_count)) {
> +					/*
> +					 * The inode is clean, inuse
> +					 */
> +					list_move(&inode->i_list, &inode_in_use);
> +				} else {
> +					/*
> +					 * The inode is clean, unused
> +					 */
> +					list_move(&inode->i_list, &inode_unused);
> +				}
> +				continue;
> +			}
> +			/* XXX: atime changed ? */
> +			list_move(&inode->i_list, &inode_in_use);
> +			continue;
> +		}
> +
> +		/* move inode in proper locality group's dirty list */
> +		spin_lock(&lg->lg_lock);
> +		list_move_tail(&inode->i_list, &lg->lg_dirty);
> +		spin_unlock(&lg->lg_lock);
> +
> +		if (!test_and_set_bit(EXT4_LG_DIRTY, &lg->lg_flags))
> +			list_move(&lg->lg_list, &sbi->s_locality_dirty);
> +	}
> +	spin_unlock(&inode_lock);
> +
> +	ext4_lg_sync_groups(sb, wbc);
> +}
Hi Alex,
I did the following test:
# mkfs /dev/sdc1
# mount -t ext4dev -o extents,mballoc,delalloc /dev/sdc1 /test
# dumpe2fs -h /dev/sdc1
# cp linux.tar /test
# tar xf /test/linux.tar
# dumpe2fs -h /dev/sdc1

The "Free blocks" and "Free inodes" counters in the dumpe2fs output did=
=20
not change after running the cp and tar commands.

I think it misses a call to ext4_commit_super() at the end of the=20
ext4_lg_sync_inodes function.
Am I right ?

    Val=E9rie
