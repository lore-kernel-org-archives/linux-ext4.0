From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 30/25] libext2fs: check ea value offset when loading
Date: Thu, 11 Sep 2014 13:17:44 -0700
Message-ID: <20140911201744.GV10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25525 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbaIKURu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 16:17:50 -0400
Content-Disposition: inline
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When reading extended attributes, check e_value_offs to make sure that
it starts in the value area and not the name area.  The attached test
case image will crash the kernel if it is mounted and you append more
than 4096 bytes of data to /a, due to insufficient validation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext_attr.c           |   29 ++++++++++++++++++++++++-----
 tests/f_ea_value_crash/expect.1 |   15 +++++++++++++++
 tests/f_ea_value_crash/expect.2 |    7 +++++++
 tests/f_ea_value_crash/image.gz |  Bin
 tests/f_ea_value_crash/name     |    1 +
 5 files changed, 47 insertions(+), 5 deletions(-)
 create mode 100644 tests/f_ea_value_crash/expect.1
 create mode 100644 tests/f_ea_value_crash/expect.2
 create mode 100644 tests/f_ea_value_crash/image.gz
 create mode 100644 tests/f_ea_value_crash/name

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index f9b9208..b52abb5 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -618,7 +618,7 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 					 size_t *nr_read)
 {
 	struct ext2_xattr *x;
-	struct ext2_ext_attr_entry *entry;
+	struct ext2_ext_attr_entry *entry, *end;
 	const char *prefix;
 	unsigned int remain, prefix_len;
 	errcode_t err;
@@ -629,20 +629,34 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 	while (x->name)
 		x++;
 
-	entry = entries;
+	/* find the end */
+	end = entries;
 	remain = storage_size;
 	while (remain >= sizeof(struct ext2_ext_attr_entry) &&
-	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
-		__u32 hash;
+	       !EXT2_EXT_IS_LAST_ENTRY(end)) {
 
 		/* header eats this space */
 		remain -= sizeof(struct ext2_ext_attr_entry);
 
 		/* is attribute name valid? */
-		if (EXT2_EXT_ATTR_SIZE(entry->e_name_len) > remain)
+		if (EXT2_EXT_ATTR_SIZE(end->e_name_len) > remain)
 			return EXT2_ET_EA_BAD_NAME_LEN;
 
 		/* attribute len eats this space */
+		remain -= EXT2_EXT_ATTR_SIZE(end->e_name_len);
+		end = EXT2_EXT_ATTR_NEXT(end);
+	}
+
+	entry = entries;
+	remain = storage_size;
+	while (remain >= sizeof(struct ext2_ext_attr_entry) &&
+	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		__u32 hash;
+
+		/* header eats this space */
+		remain -= sizeof(struct ext2_ext_attr_entry);
+
+		/* attribute len eats this space */
 		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
 
 		/* check value size */
@@ -652,6 +666,11 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 		if (entry->e_value_offs + entry->e_value_size > values_size)
 			return EXT2_ET_EA_BAD_VALUE_OFFSET;
 
+		if (entry->e_value_size > 0 &&
+		    value_start + entry->e_value_offs <
+		    (void *)end + sizeof(__u32))
+			return EXT2_ET_EA_BAD_VALUE_OFFSET;
+
 		/* e_value_block must be 0 in inode's ea */
 		if (entry->e_value_block != 0)
 			return EXT2_ET_BAD_EA_BLOCK_NUM;
diff --git a/tests/f_ea_value_crash/expect.1 b/tests/f_ea_value_crash/expect.1
new file mode 100644
index 0000000..8315358
--- /dev/null
+++ b/tests/f_ea_value_crash/expect.1
@@ -0,0 +1,15 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has INLINE_DATA_FL flag but extended attribute not found.  Truncate? yes
+
+Inode 12 extended attribute is corrupt (allocation collision).  Clear? yes
+
+Inode 13 extended attribute is corrupt (allocation collision).  Clear? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 13/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 1
diff --git a/tests/f_ea_value_crash/expect.2 b/tests/f_ea_value_crash/expect.2
new file mode 100644
index 0000000..06886a4
--- /dev/null
+++ b/tests/f_ea_value_crash/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 13/128 files (0.0% non-contiguous), 17/512 blocks
+Exit status is 0
diff --git a/tests/f_ea_value_crash/image.gz b/tests/f_ea_value_crash/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..c45fb0e1dd7d349f32bca100653a3aa428255f00
GIT binary patch
literal 2627
zcmb2|=3rp@FBrna{Pvb@j&Gs_!-My8?j7;Xch#2ln8nfEC=%_eVs#;OQS;G&&}pxH
z?|7-QrEZ(SbL7g5-JTOB@RbNADjCk4@Wazb=*suI)q0_8170n!o%hW4{m-B8&R3s%
zd;R;pdjbtpvut!f30yn=#fp1j*qig+EBGb!FCFjux7zTNfpM_{U*F-wPcHZUdsdt3
zx=uve*3fq@_rsDiw&qpkZ}Z<*SNwJIe?PPQyZSS`{@mm4Zqs*NySiQP{k<Iv^IzSH
zs4IWow^BOthVZRV$2Q(9{i7HAQGIrLz2>nveOm^Ge@$2Zt?S*m^4|aJkIG(t-WYYG
z=CULc14G0A`!kC)_vA<Zd7I7v<krXi`d=S?;?uheKlB`;Pkes&?pS$+wR5&z%-Y^O
z%P3pRA{E)y{b$*d;$)Mne5c8N6XXJF`}0|gd(VIWd20*nfV_m88Ra0+1HbEmBq<;w
z%2@hY4l_{8={|o4QgouJ{UJHo-}=|=jgwy0-INx8s~Gd^#>M)j9mgh43t0EO=)~hq
zUvtI0Hs?*h>i%cfI*I&SY`=qe%KhY{GM~%;s6KZ7*wMGPpU?b{H2kj{mwK*j+krpk
z-``JI%~XHv?UnyI^Vk1BeR$WR|D2z{*suJq`FGjB^oRHV|2Z0T-Cpqd{#rx(j{e^U
z$C@KQ$1k*9JNFl>yqbLIzVQD)tDA2YJpK4t<mJcUyle4MS0l1@kI73)$ZDj=uX8Ng
zWLC21cg5CU%3t}yj;CF{w8GxA_WhCYzxkX071gf&`u5TK?{mA4$JMU?_fp+?`E1*Q
zsy|a^f1SR0?fq*}vXWZq?ECN9TZR3-_<Ty+vE7D@XaO?H9Swoe5Eu=C(GVC7fzc44
TRtOw0`oj6orzoF+L4g4P<Nr%E

literal 0
HcmV?d00001

diff --git a/tests/f_ea_value_crash/name b/tests/f_ea_value_crash/name
new file mode 100644
index 0000000..194bbed
--- /dev/null
+++ b/tests/f_ea_value_crash/name
@@ -0,0 +1 @@
+extended attribute value conflicts with key
