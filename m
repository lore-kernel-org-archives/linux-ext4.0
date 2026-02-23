Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1706C37C11B;
	Mon, 23 Feb 2026 23:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771888966; cv=none; b=TOY4pPXVBJMwjrqsP5AJ4jyrWY3hxDqPxcC3mnIXMBKsvKG6zh1RA4EgThMIAHJ8cn28T+zzQhCthPK1RBNvHeqhvVTuZVUnOaoZ8p/7JFPHmByV/4sIDGmVGb1Tw4T0SrFgorJod5Rx2N77oJCQobeV3jqvUYCPNIOsursLYD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771888966; c=relaxed/simple;
	bh=K2sKHiDR5dYBsEc6CRdWkMy5uWadHJrfkxT/4BpVo7c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N+UEOeJekAR6Wh2jdLys8Q3r+KaJmgB0sqk+dMby3PFZBxmeVxMmAoa5T4zeLr8y6U0ggUEISuiE9vMa+QdSciLA+scwU8bp7ZQpDKrI8yK7BnuWAG3h+QbAUyfOZvHK59GOT9J0gkrs/LFf4ymZ3UZTskm+5tnvldUMls/Ujes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qE65eXnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qE65eXnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64ECC116C6;
	Mon, 23 Feb 2026 23:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771888966;
	bh=K2sKHiDR5dYBsEc6CRdWkMy5uWadHJrfkxT/4BpVo7c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qE65eXnfAAGGza8Bho3ZrpHro5P7p1KPHlSMLqjgWYRuq2nXL7A9PDtW0Ebj82p2Y
	 6FKCEMWpMyNKSH64rcD2ImfQd+nrRByW5EtyTxzfxMI6QL4ZYKsYxEL6H4C/W8c7ht
	 uszgTfUQ/REDXiEZGNKPQCZuz4y/9HJjRH1QDwChb77o+RyZVdHk8MIdjthedEoJNK
	 sR2MM32Szr+lU769Cn9b5i7iOAZb14Xm5FO4ZmD1BejLS4ff6Uwd51kOnAoY+X9ioo
	 fkClP+2Cxj66yZ4t8HV4di5Mho1kN7nC6l3QasA5P1mjdTXmWS/akNKbUyhYMD7eyn
	 VXyAPS+S/XSJw==
Date: Mon, 23 Feb 2026 15:22:45 -0800
Subject: [PATCH 09/12] fuse: overlay iomap inode info in struct fuse_inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: miklos@szeredi.hu, djwong@kernel.org
Cc: joannelkoong@gmail.com, bpf@vger.kernel.org, bernd@bsbernd.com,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177188736220.3937557.5311553585166787815.stgit@frogsfrogsfrogs>
In-Reply-To: <177188735954.3937557.841478048197856035.stgit@frogsfrogsfrogs>
References: <177188735954.3937557.841478048197856035.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It's not possible for a regular file to use iomap mode and writeback
caching at the same time, so we can save some memory in struct
fuse_inode by overlaying them in the union.  This is a separate patch
because C unions are rather unsafe and I prefer any errors to be
bisectable to this patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/fuse/fuse_i.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 1ba95d1f430c3e..f6725d699b3e26 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -188,8 +188,11 @@ struct fuse_inode {
 
 			/* waitq for direct-io completion */
 			wait_queue_head_t direct_io_waitq;
+		};
 
 #ifdef CONFIG_FUSE_IOMAP
+		/* regular file iomap mode */
+		struct {
 			/* file size as reported by fuse server */
 			loff_t i_disk_size;
 
@@ -200,8 +203,8 @@ struct fuse_inode {
 
 			/* cached iomap mappings */
 			struct fuse_iomap_cache *cache;
-#endif
 		};
+#endif
 
 		/* readdir cache (directory only) */
 		struct {

