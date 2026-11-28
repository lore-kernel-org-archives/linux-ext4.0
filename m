Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795841548;
	b=yKP2MYMoa01RTSWUQayJJNp/fOH5XHQG3fanZAoWa4YeexEBzwKnAsha6cRhgXCk57mJ
	 WmjH9oebQBWVb754ywJ/sPeE1PHjWtRiWI515EGGkfi1RRQ5Ga7zVTGWpwOiuwtqCYkXP
	 sUk9kgNvzsRcvEo9nGR1oVl8mRSWp2I+dHfYdUsxED00+1RHQZwRguulrqLDCVwHbxC0V
	 fwJAU/byRvos8PjOeVoO5n/WxSw5nxujxDd9OpWJvWVWjJlFKJ8muOmwhsM/2ygMEKZri
	 wbRjJwZ53l+fodR6Ffsw3S2z9SqMAPuXaUsnZmxeZrqt6ksMYkt9Qr0PtXhBipzrGlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795841548;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=IKRb8+/tWBaLiaQrpz7PsTRKzl74+ZET0qyuJcBZwD4=;
	b=Fp9eRz7Zmb992+eDL+BsihtMubeXE4qxQyf34vR1a1UKVJxLerSM58pfefpKmkaT5+2Z
	 L/JH6Xm63Q47awGaCjw/XtLySGn12dxdpqV5H9cD7MAeGbQl2ZCXKq3rLhhX9quCNRfiP
	 XopJ0uDeTv/ZWjJSAjtaOeMsExYVB1YDQsQFw/mW5YAX0f52GnvnZ0ehzRubjoSU2ZLYU
	 YnN/NMr/du6oJ6uk/hlxU/cFhoOFFpA7RDG923dh94XsIVmZSjQiQCKU2r0Xx8A/jRx9k
	 6jSecu8pyKix8HHMexgTQwhZCy6pXmpJZ0Y4d3IzZM6DEphVM5YxxNBefPV8wduU8mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mumFP+Q4;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18775606A31C
	for <linux-ext4@vger.kernel.org>; Sat, 28 Nov 2026 04:52:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18775606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mumFP+Q4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=IK
	Rb8+/tWBaLiaQrpz7PsTRKzl74+ZET0qyuJcBZwD4=; b=mumFP+Q4DEVNGsadbU
	TW4Eojf9JzVGkYJZcq3gIClPXvC1Q30O/NFRsx16qsjOMq1PC0A5Roa0/gmLUMwb
	eqhzEu58dl7zr6W0rQkEQk9EuuUMiiNV1Z+D2fwmFJXeIf+khlT9KsX1gMRTqhS2
	RgPHD4//jEB6MsWnTXzauYwi0=
Received: from shaos.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3vwz_XQprXZaULg--.15719S2;
	Sat, 28 Nov 2026 12:52:15 +0800 (CST)
From: shaos <shawnq1@163.com>
To: jack@suse.cz
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH] ext2: validate directory entries before rename
Date: Sat, 28 Nov 2026 04:52:14 +0000
Message-Id: <20261128045214.2649994-1-shawnq1@163.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3vwz_XQprXZaULg--.15719S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Gw4xWw4kKF4ktFy3trW8WFg_yoW7ArWkpa
	na9r9aqw4DtFyUurn5KFyjvFyYg392ka15Ka4UA3W8ua9Iq3Z3Krn7K343tF17Jws5WrWF
	9F4qqF48Ar4kXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Ut8nrUUUUU=
X-CM-SenderInfo: pvkd40jtr6il2tof0z/xtbC8QH0A2sKXgGFNQAA3J

Hello,

ext2_dotdot() advances from the first directory entry using its on-disk
rec_len without checking that the resulting '..' entry fits in the
directory block. A malformed directory can make ext2_rename() pass an
out-of-block pointer to ext2_set_link(), which hits a kernel BUG in
__block_write_begin_int(). The function also trusts the inode in '..'
without checking that it still names old_dir.

Validate the '.' and '..' records before returning the pointer, and
reject a mismatched parent before changing the directory. The malformed
image now makes rename return -EIO; valid cross-directory rename
controls still succeed.

HEAD commit:    8d7fe9885c62fc9a95bf55d9db244d9672a8aadc
git tree:       fe970b05333fb8e41da21e9e289f652abcc7cba7
source version: v7.3-23088-g8d7fe9885c62f (Linux 7.4.0-rc4)
compiler:       gcc 11.4.0, GNU ld 2.38

console output:
https://gist.githubusercontent.com/shaos26/afcee45e1ee5b8da6bbfdb8b642093a8/raw/9b9627e2a59163890b551da6521d211dc6eb5e2d/console-output.txt
kernel config:
https://gist.githubusercontent.com/shaos26/afcee45e1ee5b8da6bbfdb8b642093a8/raw/9b9627e2a59163890b551da6521d211dc6eb5e2d/kernel-config.txt
reproducer:
https://gist.githubusercontent.com/shaos26/afcee45e1ee5b8da6bbfdb8b642093a8/raw/9b9627e2a59163890b551da6521d211dc6eb5e2d/poc.c
image builder:
https://gist.githubusercontent.com/shaos26/afcee45e1ee5b8da6bbfdb8b642093a8/raw/9b9627e2a59163890b551da6521d211dc6eb5e2d/mkimage.py
build script:
https://gist.githubusercontent.com/shaos26/afcee45e1ee5b8da6bbfdb8b642093a8/raw/9b9627e2a59163890b551da6521d211dc6eb5e2d/build.sh
QEMU runner:
https://gist.githubusercontent.com/shaos26/afcee45e1ee5b8da6bbfdb8b642093a8/raw/9b9627e2a59163890b551da6521d211dc6eb5e2d/run.sh

Download the Gist files into one working directory:

    gist_id=afcee45e1ee5b8da6bbfdb8b642093a8
    gist_revision=9b9627e2a59163890b551da6521d211dc6eb5e2d
    gist_base=https://gist.githubusercontent.com/shaos26
    gist=$gist_base/$gist_id/raw/$gist_revision
    for file in console-output.txt kernel-config.txt poc.c build.sh \
        mkimage.py run.sh; do
        curl -fL "$gist/$file" -o "$file"
    done

Clone the kernel and build the test kernel from the specified revision:

    git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
    cd linux
    git checkout 8d7fe9885c62fc9a95bf55d9db244d9672a8aadc
    mkdir build
    cp ../kernel-config.txt build/.config
    make O=build olddefconfig
    make O=build -j"$(nproc)" bzImage
    cd ..

From the working directory holding the downloaded scripts, run:

    ./build.sh
    KERNEL=linux/build/arch/x86/boot/bzImage OUT=out \
        WORK=/tmp/ext2-positive ./run.sh holenopm
    KERNEL=linux/build/arch/x86/boot/bzImage OUT=out \
        WORK=/tmp/ext2-control ./run.sh holenopmcontrol

The malformed image triggers the BUG in ext2_set_link() on the
unfixed kernel. With the patch, rename returns -EIO; the valid-image
control rename succeeds. The image and QEMU commands are included in
the Gist scripts.

The trigger requires mounting a crafted ext2 image and renaming a
directory across parents. Mounting the image requires CAP_SYS_ADMIN.
This reproduces a kernel BUG; it does not demonstrate privilege
escalation or memory disclosure.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: shaos <shawnq1@163.com>

Thanks,

shaos

---
diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 5de32c221a83b..f0a23cbceed5e 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -412,10 +412,36 @@ struct ext2_dir_entry_2 *ext2_find_entry (struct inode *dir,
  */
 struct ext2_dir_entry_2 *ext2_dotdot(struct inode *dir, struct folio **foliop)
 {
+	unsigned int chunk_size = ext2_chunk_size(dir);
 	ext2_dirent *de = ext2_get_folio(dir, 0, 0, foliop);
+	unsigned int dot_len, dotdot_len;
 
-	if (!IS_ERR(de))
-		return ext2_next_entry(de);
+	if (IS_ERR(de))
+		return NULL;
+
+	if (de->name_len != 1 || de->name[0] != '.' ||
+	    le32_to_cpu(de->inode) != dir->i_ino)
+		goto bad;
+
+	dot_len = ext2_rec_len_from_disk(de->rec_len);
+	if (dot_len < EXT2_DIR_REC_LEN(1) ||
+	    dot_len > chunk_size - EXT2_DIR_REC_LEN(2))
+		goto bad;
+
+	de = ext2_next_entry(de);
+	dotdot_len = ext2_rec_len_from_disk(de->rec_len);
+	if (de->name_len != 2 || de->name[0] != '.' || de->name[1] != '.' ||
+	    !le32_to_cpu(de->inode) || dotdot_len < EXT2_DIR_REC_LEN(2) ||
+	    dotdot_len > chunk_size - dot_len)
+		goto bad;
+
+	return de;
+
+bad:
+	ext2_error(dir->i_sb, __func__,
+		   "directory #%llu has invalid '.' or '..' entry",
+		   (unsigned long long)dir->i_ino);
+	folio_release_kmap(*foliop, de);
 	return NULL;
 }
 
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index bfb6a463a95e0..a5b5aff1cfb45 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -350,6 +350,12 @@ static int ext2_rename (const struct mnt_idmap * idmap,
 		dir_de = ext2_dotdot(old_inode, &dir_folio);
 		if (!dir_de)
 			goto out_old;
+		if (le32_to_cpu(dir_de->inode) != old_dir->i_ino) {
+			ext2_error(old_inode->i_sb, __func__,
+				   "directory #%llu has incorrect '..' entry",
+				   (unsigned long long)old_inode->i_ino);
+			goto out_dir;
+		}
 	}
 
 	if (new_inode) {

