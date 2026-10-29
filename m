Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280545;
	b=2dqC8INSB7gyeFOm6ARdYztxP3ggkgRxtaMnrC/9HMx7Q6zKoT+auAab+Q0muP2C2nln
	 Dbs13MiURO6p8DJgT1rK6Dmu5WHZTg4KOEpM2n+rqcPzkE9oEWsJenXcsOpiiorYjsIEs
	 to51akyjWR0bza7sUlaE3Bhb2CGedlRiQpnEDhsJQzaUFT5ugj7+P1Wym7Ton4Lguq0OR
	 PPsalowkXz03trkBxpadNG7Eu1AJVSXcrzwTofolYToZH1/sYd18MaJ+8uXq50PpyFrIw
	 pp+YkOLtX7dhaSYvOOyhcQXPFW+KKgtBu2X8i4OzEXBRIX5nF/CphufhjsL/qveijlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280545;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=xUXQfjym1VpUfqYwunsbAo8zueNGc6qGfk0gtuwF4/c=;
	b=qwRgM5bMEGU+MxyOwM/t9f5WHpamWCaCdf4dTLcxc3yieurvitADf05KRQ7DzIUJ/zHf
	 MA2e2lF+mJ0dzeL+y3fXRa9hKWb5AiRJDNi38uH0LMevCQB5XoazeAaUm2EmURiBLyAYG
	 HVKBd8wP0tsbMR1OWVsVhZrnH5mpDp4bKKctYOBowk+rNwUp2YO1SfiJzi17Qijtt8FBM
	 bbtagWi8RJpRSWAzudjlG08+9e0ekGF3V1CJy89HVf7LiPiF4Ix29EVT9ZdZZkWG0xsqw
	 K8d3DdpTvbqmK/zai5vvUravjs9Zj1XWAQts9GvAcAFRhsu/QRIwFdHewRw4Gm6IuvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=muYCAmvU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D04E606A33A;
	Thu, 29 Oct 2026 13:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=muYCAmvU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071EA1F031E4;
	Thu, 29 Oct 2026 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280545;
	bh=xUXQfjym1VpUfqYwunsbAo8zueNGc6qGfk0gtuwF4/c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=muYCAmvUvdW0Gpmr5M8XrAqRqm2nV0OntOO0zb9i+hn7wxyYvPoCV6BHe2vq+Snwy
	 OEEZGp4VCVg6UkEJsWpZrdnTwYgJ4cv5HPJoPoGRitUAsvAhwBz9A4LAu4xJhzKK+3
	 AqHwSlDoo3Wbap9sL2fmStHa6ELTuFYlrAuAIKblO/FhFJBgC/hMfDw+TnbvgdWOpy
	 ypEAhbtCsIXpldEdl5yQVY4UY7iOD6ITSuHuODBlQyIWJivevQ0FDyhvaQ2O9SE+mr
	 Tt8xDJ0tVKzUUR1yRfbhGc205+OfYdnYUyuj1CCn30MHnjZ5OeQEWywCn67Brhtt4T
	 94yzQsNM/iEsw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 14:28:23 +0100
Subject: [PATCH RFC 8/9] fat: sync the inode in fat_free_eofblocks()
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-inode-metadata_writeback-v1-8-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Namjae Jeon <namjae.jeon@samsung.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2903; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8lvqhM3ApZQ+kbx8+iSkGCsrCx+KHhtsxiY9gd8+6KI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99vz/8hVnbMTqydL/ZF60aooqFPzXec7vUFkcsaSU8
 ZmzXId/RwkLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwER+OzD8d9c+HfZ72+ucQPUX
 e7vFvjzwUM+bklFyyFbcQfVhhc0/WYYfs1ytLjrdPnE9aNo81o4mubOTeRckuu1Ot8qalVsc18k
 GAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

fat_evict_inode() calls fat_free_eofblocks() for a linked inode to give
back the clusters that were fallocated past the initialized size. For an
empty file that also resets the start cluster in the directory entry. It
truncates the clusters and writes the inode with:

  sync_inode_metadata(inode, inode_needs_sync(inode));

Unless the inode is IS_SYNC that is WB_SYNC_NONE writeback. It copies
the inode into the directory entry buffer, marks the buffer dirty and
sets I_METADATA_WRITEBACK. Then the inode goes away and with it the only
thing that would have told a later fsync() that the directory entry
still has to be written.

FAT doesn't have that problem. Its buffers are tracked on the FAT inode
and fat_file_fsync() writes them out on every fsync() of any file on the
filesystem.

So after the next fsync() the clusters are free on disk while the
directory entry of the empty file still points at them. If another file
reuses them and the machine crashes before the directory entry makes it
to disk, the two files share clusters. That's the corruption the comment
in fat_free_eofblocks() is about.

So wait for the directory entry to reach the disk before the inode goes
away.

Reproducer. The image file shows what reached the disk. The flusher is
turned off so that it doesn't write the directory entry before fsck.fat
looks at the image:

  img=/tmp/fat.img
  truncate -s 64M $img
  mkfs.vfat $img > /dev/null
  dev=$(losetup -f --show $img)
  mount -t vfat $dev /mnt
  echo 0 > /proc/sys/vm/dirty_writeback_centisecs
  xfs_io -f -c 'falloc -k 0 1m' -c fsync /mnt/a
  echo 3 > /proc/sys/vm/drop_caches
  echo 3 > /proc/sys/vm/drop_caches
  xfs_io -c fsync /mnt/a
  fsck.fat -n $img | grep -A1 '^/a'
  umount /mnt
  losetup -d $dev

On v7.3-17318-g65ba8f34ec88 in a KASAN and lockdep vng guest this
prints:

  /a
    Contains a free cluster (3). Assuming EOF.

With this patch fsck.fat finds nothing wrong with /a.

The stable tag is narrower than the Fixes tag. Before v7.3
fat_free_eofblocks() called __fat_write_inode() directly and the fix
there is to pass 1 for wait.

Fixes: b13bb33eacb7 ("fat: add fat_fallocate operation")
Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fat/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index d85c8fbdcca4..fc571ee2b174 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -675,7 +675,7 @@ static void fat_free_eofblocks(struct inode *inode)
 		 * any corruption on the next access to the cluster
 		 * chain for the file.
 		 */
-		err = sync_inode_metadata(inode, inode_needs_sync(inode));
+		err = sync_inode_metadata(inode, 1);
 		if (err) {
 			fat_msg(inode->i_sb, KERN_WARNING, "Failed to "
 					"update on disk inode for unused "

-- 
2.53.0

