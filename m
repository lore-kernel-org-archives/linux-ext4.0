Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9C03A9629
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014120; cv=none; b=lEWUoUO92OIF0WX8U4cOrz7pqz2x4wGi6xBuDSdil//tyAE0JWCpSMFhxTCKJrzSVNnD7PXlddOFEPfQjN2+GBN3gaIy2nya0DDPbmNqvsGAjaa8lZGFARYCJg/gTEHLGsF6gOeFS8i20zYeCnHvgMIo9G5L04WjTesGGLlBB3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014120; c=relaxed/simple;
	bh=sQnfAAliYSp6hPEKRpw+XvFpoGUUmiuU80fuBNLrow8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmpY87utAvfieo3+jtL0kxJ5nnBDhpb+Lcuno0Zdoi6pT0MM47wI88sdomDKIHETxZp4cy2eX/2YmrJ0MkHlc0hX1/VPqwPgtGipbsd/j+Gjr8VjuemnibIpEvn1hpuSWFtHsY0i6KDgzyXQvc+Uh+kMsw3HFsAnXJyAqQgXJ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0E2B54D279;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 014044281D;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dZVTAJlOvWlcCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9337AA0B4F; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 08/41] udf: Switch to generic_buffers_fsync()
Date: Fri, 20 Mar 2026 14:41:03 +0100
Message-ID: <20260320134100.20731-49-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1173; i=jack@suse.cz; h=from:subject; bh=sQnfAAliYSp6hPEKRpw+XvFpoGUUmiuU80fuBNLrow8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5zss1fVh17XzrzLExYByxBIN76SuLhi3EVy qdBUx84BCuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OcwAKCRCcnaoHP2RA 2ZmlB/4pwEMzrAOODbjtj7HaY5ff7Veyc1fItqr9eNLjpXqz8vZ/ZstgKFGe7nYTYJtIj/I0jaC B7Gv00KYk9uFMihnUz+r/7FZ+R08vO77QoMacpILWEHZeNur88oTvgDn9paD6UTGVF5V4AM6qeI m/Wc8HYIoljOmAFSvswZK7uSvwO44o8VSvMeffz3YHGY+rSpuCsp3vCVBALEeSwjD0jZLlqy08m d8lfCw1TLSZIB77LiT3NY5EURQtY8pNEJIxcuMJYfXB5mR5yHtKKpmqoVb+5Rox/RZbxw/03Jwf m5SlWOC/EJqg+kl1DaPipN0EsijO/WFuX+NlM0a+91BBLDHC
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: 0E2B54D279
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

UDF uses metadata bh list attached to inode. Switch it to
generic_buffers_fsync() instead of generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/dir.c  | 2 +-
 fs/udf/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 5bf75638f352..a1705aedac46 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -157,6 +157,6 @@ const struct file_operations udf_dir_operations = {
 	.read			= generic_read_dir,
 	.iterate_shared		= udf_readdir,
 	.unlocked_ioctl		= udf_ioctl,
-	.fsync			= generic_file_fsync,
+	.fsync			= generic_buffers_fsync,
 	.setlease		= generic_setlease,
 };
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 32ae7cfd72c5..627b07320d06 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -205,7 +205,7 @@ const struct file_operations udf_file_operations = {
 	.mmap			= udf_file_mmap,
 	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
-	.fsync			= generic_file_fsync,
+	.fsync			= generic_buffers_fsync,
 	.splice_read		= filemap_splice_read,
 	.splice_write		= iter_file_splice_write,
 	.llseek			= generic_file_llseek,
-- 
2.51.0

