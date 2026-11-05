Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882568;
	b=sr3yHkJkHUUja1HVJ3GAj5qqGxkKP4NsuPOxjIyINhrZuPzGosDpsJuizT3Vc31NaurT
	 6OxOxQ4Sp1lQUZ/QMYaeJUaxK4x69ZCvs72G8ehyR3YksHIYzj9XT/B2TjmTdweMTjzBS
	 nBx5oICefu6xdcbUwZ5JX/LBVCTQlOFbHDQD6kcQDmvLw3l3SQ5G2igae+5qHVe7KGkUr
	 /mwhrPYfs7SeNFRZ1Kz6fGL37y6vwTpvzElVwez96ey8grDR4yQvjZGeV81BWUptUoh0f
	 H8YfqtMdezqOEYWqEwAvhxjQ5EFutE6I8gEqdWxoYqaJXcSYbfs2EA8ELMY3tIKKVPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882568;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=uW3JsIhVFAwyT3ql8Ud0CDR614EgO2l3PnFYcnLviYw=;
	b=yQd6+8lh2Jdv9mh40SjEm1dsfqSVfI3XUFSbPmRSBEiyK9tAnpmaYBffQdfKbm6uaQg4
	 tSY0okoDvM647IzjrnChLUc2Qv1RuFAETwFykq9yka5mWVc+8tsv6HskGnuCWrdVZfsgT
	 MP4cZ8tc1/8HaIBrQDjqd3hB2UNzpZ84HPR32qtosTkH1bLMfXKzPmzV3Py7Vp+6SB40x
	 Wu61R80+MqDBE8XlDi27ABjg5T/FbiEkWieP6hiSJAW83voxSwHdonK9Xd9NU/dD/Vr/C
	 9euEkbyVikWVZLjRscvI9A4YfMvdFpgJrIotbnp7N9nR3MZw9g9uS+F8fFUJ9jbY9Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eg2oMe9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D082606D814;
	Thu,  5 Nov 2026 12:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eg2oMe9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D031F00919;
	Thu,  5 Nov 2026 12:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882568;
	bh=uW3JsIhVFAwyT3ql8Ud0CDR614EgO2l3PnFYcnLviYw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eg2oMe9EQyrLlTySAlsrMtx8QS4nNn/NJfu8/OODA0ox7E5Na+VtNTtck5CT6sMyz
	 vDIUymYLX03kOL4z0FntK8Z4uiVUeGqi7yXg+hH9WlTjL86YV+tWcP1Eii/Manev4B
	 YwgY2QWij6IsYPmJ8AmbTFULdSAWUv3P6+xfhC8Csh8FHWbz5hsp1DZUkjna/ZuP5U
	 BoI/+IGx0A5ZrreHnTyYrfOeVUvxIm1n+rIz1LjyDBZPaW2QyRqF43yIxFZqnmGvgK
	 hVqONbKP9h0PXdTyw+fTdegj/hsh149V2qS3gUO1m3oQPXqoWhNtIE6JzPT4DCgDKC
	 oDdCcCn/hk9OQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:40 +0100
Subject: [PATCH RFC v2 11/13] udf: sync inode metadata in udf_evict_inode()
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-11-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1806; i=brauner@kernel.org;
 h=from:subject:message-id; bh=i0yiMrvON4FraxfwXdvfqy52+otzr1i7gCUy6miLT70=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZwzq8hC0+JA972uWKNzu17d4q3nvPlo3RvrY5Ncm
 9L1Y3kPdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk2GuG//WfUzodi9htDodu
 67x2JuWO0o19O9+c5gtrDmIM+/0guZ7hn87yjY0zoma/4eZKfvdY86pbqHqJjFixWuYs+ZaTE+Z
 bMAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

udf_write_inode() copies the inode into the block that holds it, marks
the block dirty and sets I_METADATA_WRITEBACK so that a later fsync()
writes the block out and waits for it. But the bit goes away with the
inode. If the inode is evicted and read back in, fsync() finds a clean
inode and returns while the block might still be dirty or under
writeback.

Right now that can't happen because inode_lru_isolate() never lets go
of an inode with I_METADATA_WRITEBACK set. That is about to change.

So call udf_sync_inode_metadata() from udf_evict_inode() for an inode
that isn't deleted and still has the bit set. It syncs the metadata
buffers as well so it replaces the mmb_sync() there, and since the
previous patch it doesn't allocate anything.

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/udf/inode.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index b3e7c07cb9e7..8f45133ce75a 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -152,8 +152,18 @@ void udf_evict_inode(struct inode *inode)
 		}
 	}
 	truncate_inode_pages_final(&inode->i_data);
-	if (!want_delete)
-		mmb_sync(&iinfo->i_metadata_bhs);
+	if (!want_delete) {
+		/*
+		 * fsync() can't find what I_METADATA_WRITEBACK tracks once the
+		 * inode is gone. This syncs the metadata buffers as well.
+		 */
+		if (inode_state_read_once(inode) & I_METADATA_WRITEBACK)
+			udf_sync_inode_metadata(inode, &(struct writeback_control) {
+				.sync_mode = WB_SYNC_ALL,
+			});
+		else
+			mmb_sync(&iinfo->i_metadata_bhs);
+	}
 	mmb_invalidate(&iinfo->i_metadata_bhs);
 	clear_inode(inode);
 	kfree(iinfo->i_data);

-- 
2.53.0

