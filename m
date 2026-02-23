Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E0234DCE2;
	Mon, 23 Feb 2026 23:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771889310; cv=none; b=DuHGngYr7l4rg796Ez7Q8mi/j4NZcozcXFnpbHtCVtr9nSO2HztxGqOz1kJhCgkeTJ9mgCEOIzS4iXBxHDDZkOZ8GT4nIeu5d6wGE/KYPRbPqB1KJ94eKqTW+GUN+aVZDrzoOAI1xCHOOKDPmG//vnNBc/DLdPXAtCVPT3YN+jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771889310; c=relaxed/simple;
	bh=PgGfZm9r/9VS5+N7rx8Y75iNFoADsHCNwfI6PRW7KHw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrM+rKPZ06iD0D079TK3UuddOch2+5u7FgDtoDknVyhgiqPWY944by6NC8XS1QOfBTpLVHX/u14oHergWXpLVEZw1yv1Fi0oX7c1p65G0ZVAAGBLULVfH+gNgUbNqLUl0yrprR8jZBCzIKaMdc1kopuR+VoDk/nh6sFdWLj8bfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HElfiH8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HElfiH8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9E4C19421;
	Mon, 23 Feb 2026 23:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771889309;
	bh=PgGfZm9r/9VS5+N7rx8Y75iNFoADsHCNwfI6PRW7KHw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HElfiH8cdq7MSajq3OWa7LSe1iVTzoy1w0QRs0XuJ2CfSUkZy8UalLmopBqZyI4tH
	 wKDcUyk6QP9ih61GY8Mbyz2VIkbmnEaYKvx3XFSsaV/pfVcpPmRyV6gsSAVJLMzeBM
	 Du9Oy6z/t40SGtc1IwbpdfJ9qjGoyzPlZVhBt5Lzt7nnWQ0V26Fj55s/FKkjHtrfFH
	 VE9Ix1RqdgDJYN1xdUhdKY7tbuPwVI5G3gXkzBq09ZZPxhb/SBasyrMnyOV7RmArA1
	 3cvTDON/GfESr/SH72wjwUMZFyMaNXIOpLn1dpr04KpEwFUem6JESKIvSZtk9U868j
	 QF6K0/nMj+Vgw==
Date: Mon, 23 Feb 2026 15:28:29 -0800
Subject: [PATCH 12/25] libfuse: support enabling exclusive mode for files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, bschubert@ddn.com
Cc: bernd@bsbernd.com, miklos@szeredi.hu, neal@gompa.dev,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 bpf@vger.kernel.org, joannelkoong@gmail.com
Message-ID: <177188740150.3940670.11078101609449329839.stgit@frogsfrogsfrogs>
In-Reply-To: <177188739839.3940670.15233996351019069073.stgit@frogsfrogsfrogs>
References: <177188739839.3940670.15233996351019069073.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make it so that lowlevel fuse servers can ask for exclusive mode.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/fuse_common.h |    2 ++
 include/fuse_kernel.h |    4 ++++
 lib/fuse_lowlevel.c   |    2 ++
 3 files changed, 8 insertions(+)


diff --git a/include/fuse_common.h b/include/fuse_common.h
index f34f4be6a61770..a21f1c8dd12e91 100644
--- a/include/fuse_common.h
+++ b/include/fuse_common.h
@@ -1223,6 +1223,8 @@ static inline bool fuse_iomap_need_write_allocate(unsigned int opflags,
 
 /* enable fsdax */
 #define FUSE_IFLAG_DAX			(1U << 0)
+/* exclusive attr mode */
+#define FUSE_IFLAG_EXCLUSIVE		(1U << 1)
 
 /* ----------------------------------------------------------- *
  * Compatibility stuff					       *
diff --git a/include/fuse_kernel.h b/include/fuse_kernel.h
index 732085a1b900b0..9b0894899ca453 100644
--- a/include/fuse_kernel.h
+++ b/include/fuse_kernel.h
@@ -244,6 +244,7 @@
  *  7.99
  *  - XXX magic minor revision to make experimental code really obvious
  *  - add FUSE_IOMAP and iomap_{begin,end,ioend} for regular file operations
+ *  - add FUSE_ATTR_EXCLUSIVE to enable exclusive mode for specific inodes
  */
 
 #ifndef _LINUX_FUSE_H
@@ -584,9 +585,12 @@ struct fuse_file_lock {
  *
  * FUSE_ATTR_SUBMOUNT: Object is a submount root
  * FUSE_ATTR_DAX: Enable DAX for this file in per inode DAX mode
+ * FUSE_ATTR_EXCLUSIVE: This file can only be modified by this mount, so the
+ * kernel can use cached attributes more aggressively (e.g. ACL inheritance)
  */
 #define FUSE_ATTR_SUBMOUNT      (1 << 0)
 #define FUSE_ATTR_DAX		(1 << 1)
+#define FUSE_ATTR_EXCLUSIVE	(1 << 2)
 
 /**
  * Open flags
diff --git a/lib/fuse_lowlevel.c b/lib/fuse_lowlevel.c
index c21e64787215cc..f34c86406552f9 100644
--- a/lib/fuse_lowlevel.c
+++ b/lib/fuse_lowlevel.c
@@ -164,6 +164,8 @@ static void convert_stat(const struct stat *stbuf, struct fuse_attr *attr,
 	attr->flags	= 0;
 	if (iflags & FUSE_IFLAG_DAX)
 		attr->flags |= FUSE_ATTR_DAX;
+	if (iflags & FUSE_IFLAG_EXCLUSIVE)
+		attr->flags |= FUSE_ATTR_EXCLUSIVE;
 }
 
 static void convert_attr(const struct fuse_setattr_in *attr, struct stat *stbuf)

