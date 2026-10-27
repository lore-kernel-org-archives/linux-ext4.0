Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135403;
	b=0OM76dPJKL8Jqo94reo3Ndg77RtBZTZjHVLofToBdLJ1kCrc6Uxv0KAtPPZhqW/yszhc
	 k9ivJJeZeEMExlXxs34nL5BXYqNyTD+uaBfKJqDbP5neYXxnUceGVtg0hl4au2znj8h0P
	 NYcIqi0dgJSy/viagbKp/PijsHTXq03NQbTxGCbo10TXa2gAuVcLi3yxHc65QJzLrEtC2
	 omS0fhCf/vX6yII5j1SMWRxSk2Aw50SFOkJ/rEaPKDot0+MrcB8DHWklp0phgifP56F0Q
	 6sRgVHUFEUAWQADf/zvH3PjjipHOVBmEiAv3m89XFnc4l+XqZrD3fl+AiWiLXxLCZiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135403;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=ruUe/GT1VwTWup+0kZscWxZsaccg4YfsFi7B4zNopuY=;
	b=ok1QCvPIUWP5d7ABe+KDEx2Ok91CkEJitgk5VaENdlH2DoIMrTlsjix2E5COpXFhOhSn
	 dJFBLvBCV0dy9IQAM08y8BPSBvZR5LfvTyCEGr0uXKABeVFNiQ9KlD/jhHh92dvtiyw4N
	 nbQJjyYykmxiGs95SQ+CYytPSaHNpcFOehGSTvPlhtDrWN1sQG8e9lB1+472OCtXzhbCH
	 5GKDI3rvbjqQ+g1QN9hs9BhAFHIbk9YPByZXEH39gCzRhMOn6045zDQ1RqCKZXcb+0UgR
	 52E5Mp1+N6OriKF8iIHlJ3rVruwR3lOx3FJHHnWqv088l448Yq5fdSvVu4DL6nvXb3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=IoxGeVeq;
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6170F606A31E
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:09:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6170F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=IoxGeVeq
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93ece7a73b9so21645885a.3
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 14:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135393; x=1793740193; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ruUe/GT1VwTWup+0kZscWxZsaccg4YfsFi7B4zNopuY=;
        b=IoxGeVeqBEBSmQts5lMdLN8woJchkwrQhTP1FM2zkR5Bh4JuIjr+yhs2YhSDU+Yxte
         leNiRxv+InvWr5gIKFwVPV1oTR363VDuyxDNizD41Nmhr3xq7m0BtCMR17XzU0e+4UHP
         PMCXZ0jLEO6qZL2Qnhn/1Fl+r68uonRO98yVtZwC+9+Mg9bIXKyFezWADFHIXdlzYnt6
         Blo8+32PA3mGKclSfmd4hOL/mSq0X00aox9zpZ2kvzMTyo8T+j1X0+L0eVYSKqCCCxir
         z4G8AhSR4MbQ6tNODIg6xahVCXkyFVfAgsEZU3+WD6ZDWdWRvIiMMSY9Bb565Mnke5hG
         MaxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135393; x=1793740193;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ruUe/GT1VwTWup+0kZscWxZsaccg4YfsFi7B4zNopuY=;
        b=qWtJzaKA2d/8NiolD2tGT5F5n9j7a7XL8vHBjvtCXSXFdUZCxnzGjR+oTq5RSf608J
         TdJWVZeFBZwpYwrWvIvJy8xcQknUu1QEoZJh8iLw6B24mIvBAROIlOMm7xHRlyfL6iTZ
         i6s8WsmF/4JxQHMaSuUESLG20H5+KMeklrfeEoWZ26znk1gy8ZWFw1KFBekJv/zxY5fw
         ywzToYjNPrS37rkxWrO/uVemTLnUAjr5ZkeZCiaE2qOf1BsDNkxrAjAEJzsZE8nTZMNw
         nkS0xPtQgktGFydTTliKqc9w9xeo+VdXoew94S4cUYOA7Kj7F8eMRrTFptem92bK9Czr
         Z6EA==
X-Forwarded-Encrypted: i=1; AKwUvBwK2JL6jLAs8hkkSRC4xGpWgW3xcNRPwh7LOtsT1v1h55WHTPFQ5OVH0RJWywekySbZjaImFvVDeLMV@vger.kernel.org
X-Gm-Message-State: AFq9FYLTfaOggDQuFDIf6ZWolMIfx3ujz9/m+2LrFmsDwebLLfRunvMr
	zUY73KmzDW+ECEft2R03+9i+FgUyClFEjGjGEQqEyNuAuOeyewEwfJfva/W8XmtW0AE=
X-Gm-Gg: AYBFou3VVxUdv4UUekmQTozQoOdYoSNZ+vA6u9aPy4cV1f0wXUkMqAas7qbXWjjXunw
	B4hO+lDlHMZo2FQAJuSyraEWvlpicdUHb307KULwyUmRI2MUP3PxCpZsNBnugmhiyq7yGtFeWco
	VBJafNpi63QZ1qKB3M+e1XnutqnsRdlH4vP+9b/nxVtYT/0KqkQ0/Am8Scw0cz/24k4l4qlUHHn
	RK1xHNFb8vLtsK79rDO9DZCJ8vwMWq0/7LAUYlQKW9RldWrBuvQPySJtEF/+NVGuEqLrPaZeEia
	9XZcWrxdTiH/r7Q+4SqA2vwvjl9TiJQUsUx2EMO6QLec2vshJMrfGWi+bV/IQcDX68CE/1eRMpi
	EG26DgWswLVeynOOtR/cu6l8tHEx909xb3WIj9mp2naK8VL2pCJrOHDbqUiBkvW7tZjOs1QEosM
	N+EZ7kqJRKKku8LG9EoPOaVWjjk3H0b9g92T3Uio9XHRLWgSSzwfd2V6C0ku5H2zUp8kaQVEs1A
	KHj7NmVLSmA9uqqB16emqBbmMHVlUbjcVbtL0+5I90tp5J85qo1+W94Pex78mGSN6KutfjA
X-Received: by 2002:a05:620a:4493:b0:93f:22f1:97bc with SMTP id af79cd13be357-94408de75c8mr18726285a.67.1793135393395;
        Tue, 27 Oct 2026 14:09:53 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f067f330sm1084514685a.24.2026.10.27.14.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:52 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:31 +0000
Subject: [PATCH 05/10] ovl: setup overlayfs' private bdi
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-5-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Chengguang Xu <charliecgxu@tencent.com>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=2034;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=lziNTGyBXCfixzwcVc9Cou0+3eIhaEcTmEq8NjswuHo=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHLL2F6/3sZZIvVsxBFVSkIADBBqshg/4ymc2ZgQRMYc3B/GsdwvVOAx96LCUD50tTTuAHAhKGq
 EuZawjuR9KQs=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Setup overlayfs' private bdi so that we can collect overlayfs' own dirty
inodes.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: only for an overlay which is going to have dirty inodes, rebased]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/overlayfs.h | 13 +++++++++++++
 fs/overlayfs/super.c     |  7 +++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 92da556598da..218f646b82b9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -663,6 +663,19 @@ static inline bool ovl_should_sync(struct ovl_fs *ofs)
 	return ofs->config.fsync_mode != OVL_FSYNC_VOLATILE;
 }
 
+/*
+ * Does this overlay keep track of the upper inodes which are changed through
+ * it, to sync only those?  It knows where it wrote data.  It does not know of
+ * every inode which the upper filesystem dirtied on its behalf, so that has to
+ * be a filesystem where ->sync_fs() takes care of all metadata.  With any other
+ * one syncfs() and unmount sync the whole upper filesystem.
+ */
+static inline bool ovl_tracks_dirty(struct ovl_fs *ofs)
+{
+	return ovl_upper_mnt(ofs) && ovl_should_sync(ofs) &&
+	       (ovl_upper_mnt(ofs)->mnt_sb->s_iflags & SB_I_OVL_USE_SYNC_FS);
+}
+
 static inline bool ovl_should_sync_metadata(struct ovl_fs *ofs)
 {
 	return ofs->config.fsync_mode == OVL_FSYNC_STRICT;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 19b6d54c4500..d21e7cbb70c2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1455,6 +1455,13 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 		if (err)
 			return err;
 
+		/* Dirty overlay inodes need a writeback list to be on */
+		if (ovl_tracks_dirty(ofs)) {
+			err = super_setup_bdi(sb);
+			if (err)
+				return err;
+		}
+
 		upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
 		if (!ovl_should_sync(ofs)) {
 			ofs->errseq = errseq_sample(&upper_sb->s_wb_err);

-- 
2.55.0

