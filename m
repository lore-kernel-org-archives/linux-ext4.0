Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38415C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 20:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD63020989
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 20:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfCRU2S (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 16:28:18 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33002 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727472AbfCRU2Q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2019 16:28:16 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 148E128119E
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, jlayton@kernel.org, bfields@fieldses.org,
        paulus@samba.org, linux-fsdevel@vger.kernel.org,
        Olaf Weber <olaf@sgi.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v6 04/11] unicode: reduce the size of utf8data[]
Date:   Mon, 18 Mar 2019 16:27:38 -0400
Message-Id: <20190318202745.5200-5-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190318202745.5200-1-krisman@collabora.com>
References: <20190318202745.5200-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Olaf Weber <olaf@sgi.com>

Remove the Hangul decompositions from the utf8data trie, and do
algorithmic decomposition to calculate them on the fly. To store
the decomposition the caller of utf8lookup()/utf8nlookup() must
provide a 12-byte buffer, which is used to synthesize a leaf with
the decomposition. Trie size is reduced from 245kB to 90kB.

Signed-off-by: Olaf Weber <olaf@sgi.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
  [Rebase to mainline]
  [Fix checkpatch errors]
  [Extract robustness fixes and merge back to original mkutf8data.c
  patch]
---
 fs/unicode/utf8-norm.c | 191 ++++++++++++++++++++++---
 fs/unicode/utf8n.h     |   4 +
 scripts/mkutf8data.c   | 307 +++++++++++++++++++++++++++++++++++------
 3 files changed, 443 insertions(+), 59 deletions(-)

diff --git a/fs/unicode/utf8-norm.c b/fs/unicode/utf8-norm.c
index 4ed50f3fda6e..845c0f300370 100644
--- a/fs/unicode/utf8-norm.c
+++ b/fs/unicode/utf8-norm.c
@@ -98,6 +98,38 @@ static inline int utf8clen(const char *s)
 	return 1 + (c >= 0xC0) + (c >= 0xE0) + (c >= 0xF0);
 }
 
+/*
+ * Decode a 3-byte UTF-8 sequence.
+ */
+static unsigned int
+utf8decode3(const char *str)
+{
+	unsigned int		uc;
+
+	uc = *str++ & 0x0F;
+	uc <<= 6;
+	uc |= *str++ & 0x3F;
+	uc <<= 6;
+	uc |= *str++ & 0x3F;
+
+	return uc;
+}
+
+/*
+ * Encode a 3-byte UTF-8 sequence.
+ */
+static int
+utf8encode3(char *str, unsigned int val)
+{
+	str[2] = (val & 0x3F) | 0x80;
+	val >>= 6;
+	str[1] = (val & 0x3F) | 0x80;
+	val >>= 6;
+	str[0] = val | 0xE0;
+
+	return 3;
+}
+
 /*
  * utf8trie_t
  *
@@ -159,7 +191,8 @@ typedef const unsigned char utf8trie_t;
  *          characters with the Default_Ignorable_Code_Point property.
  *          These do affect normalization, as they all have CCC 0.
  *
- * The decompositions in the trie have been fully expanded.
+ * The decompositions in the trie have been fully expanded, with the
+ * exception of Hangul syllables, which are decomposed algorithmically.
  *
  * Casefolding, if applicable, is also done using decompositions.
  *
@@ -179,6 +212,105 @@ typedef const unsigned char utf8leaf_t;
 #define STOPPER		(0)
 #define	DECOMPOSE	(255)
 
+/* Marker for hangul syllable decomposition. */
+#define HANGUL		((char)(255))
+/* Size of the synthesized leaf used for Hangul syllable decomposition. */
+#define UTF8HANGULLEAF	(12)
+
+/*
+ * Hangul decomposition (algorithm from Section 3.12 of Unicode 6.3.0)
+ *
+ * AC00;<Hangul Syllable, First>;Lo;0;L;;;;;N;;;;;
+ * D7A3;<Hangul Syllable, Last>;Lo;0;L;;;;;N;;;;;
+ *
+ * SBase = 0xAC00
+ * LBase = 0x1100
+ * VBase = 0x1161
+ * TBase = 0x11A7
+ * LCount = 19
+ * VCount = 21
+ * TCount = 28
+ * NCount = 588 (VCount * TCount)
+ * SCount = 11172 (LCount * NCount)
+ *
+ * Decomposition:
+ *   SIndex = s - SBase
+ *
+ * LV (Canonical/Full)
+ *   LIndex = SIndex / NCount
+ *   VIndex = (Sindex % NCount) / TCount
+ *   LPart = LBase + LIndex
+ *   VPart = VBase + VIndex
+ *
+ * LVT (Canonical)
+ *   LVIndex = (SIndex / TCount) * TCount
+ *   TIndex = (Sindex % TCount)
+ *   LVPart = SBase + LVIndex
+ *   TPart = TBase + TIndex
+ *
+ * LVT (Full)
+ *   LIndex = SIndex / NCount
+ *   VIndex = (Sindex % NCount) / TCount
+ *   TIndex = (Sindex % TCount)
+ *   LPart = LBase + LIndex
+ *   VPart = VBase + VIndex
+ *   if (TIndex == 0) {
+ *          d = <LPart, VPart>
+ *   } else {
+ *          TPart = TBase + TIndex
+ *          d = <LPart, TPart, VPart>
+ *   }
+ */
+
+/* Constants */
+#define SB	(0xAC00)
+#define LB	(0x1100)
+#define VB	(0x1161)
+#define TB	(0x11A7)
+#define LC	(19)
+#define VC	(21)
+#define TC	(28)
+#define NC	(VC * TC)
+#define SC	(LC * NC)
+
+/* Algorithmic decomposition of hangul syllable. */
+static utf8leaf_t *
+utf8hangul(const char *str, unsigned char *hangul)
+{
+	unsigned int	si;
+	unsigned int	li;
+	unsigned int	vi;
+	unsigned int	ti;
+	unsigned char	*h;
+
+	/* Calculate the SI, LI, VI, and TI values. */
+	si = utf8decode3(str) - SB;
+	li = si / NC;
+	vi = (si % NC) / TC;
+	ti = si % TC;
+
+	/* Fill in base of leaf. */
+	h = hangul;
+	LEAF_GEN(h) = 2;
+	LEAF_CCC(h) = DECOMPOSE;
+	h += 2;
+
+	/* Add LPart, a 3-byte UTF-8 sequence. */
+	h += utf8encode3((char *)h, li + LB);
+
+	/* Add VPart, a 3-byte UTF-8 sequence. */
+	h += utf8encode3((char *)h, vi + VB);
+
+	/* Add TPart if required, also a 3-byte UTF-8 sequence. */
+	if (ti)
+		h += utf8encode3((char *)h, ti + TB);
+
+	/* Terminate string. */
+	h[0] = '\0';
+
+	return hangul;
+}
+
 /*
  * Use trie to scan s, touching at most len bytes.
  * Returns the leaf if one exists, NULL otherwise.
@@ -187,8 +319,8 @@ typedef const unsigned char utf8leaf_t;
  * is well-formed and corresponds to a known unicode code point.  The
  * shorthand for this will be "is valid UTF-8 unicode".
  */
-static utf8leaf_t *utf8nlookup(const struct utf8data *data, const char *s,
-			       size_t len)
+static utf8leaf_t *utf8nlookup(const struct utf8data *data,
+			       unsigned char *hangul, const char *s, size_t len)
 {
 	utf8trie_t	*trie = utf8data + data->offset;
 	int		offlen;
@@ -226,8 +358,7 @@ static utf8leaf_t *utf8nlookup(const struct utf8data *data, const char *s,
 				trie++;
 			} else {
 				/* No right node. */
-				node = 0;
-				trie = NULL;
+				return NULL;
 			}
 		} else {
 			/* Left leg */
@@ -237,8 +368,7 @@ static utf8leaf_t *utf8nlookup(const struct utf8data *data, const char *s,
 				trie += offlen + 1;
 			} else if (*trie & RIGHTPATH) {
 				/* No left node. */
-				node = 0;
-				trie = NULL;
+				return NULL;
 			} else {
 				/* Left node after this node */
 				node = (*trie & TRIENODE);
@@ -246,6 +376,14 @@ static utf8leaf_t *utf8nlookup(const struct utf8data *data, const char *s,
 			}
 		}
 	}
+	/*
+	 * Hangul decomposition is done algorithmically. These are the
+	 * codepoints >= 0xAC00 and <= 0xD7A3. Their UTF-8 encoding is
+	 * always 3 bytes long, so s has been advanced twice, and the
+	 * start of the sequence is at s-2.
+	 */
+	if (LEAF_CCC(trie) == DECOMPOSE && LEAF_STR(trie)[0] == HANGUL)
+		trie = utf8hangul(s - 2, hangul);
 	return trie;
 }
 
@@ -255,9 +393,10 @@ static utf8leaf_t *utf8nlookup(const struct utf8data *data, const char *s,
  *
  * Forwards to utf8nlookup().
  */
-static utf8leaf_t *utf8lookup(const struct utf8data *data, const char *s)
+static utf8leaf_t *utf8lookup(const struct utf8data *data,
+			      unsigned char *hangul, const char *s)
 {
-	return utf8nlookup(data, s, (size_t)-1);
+	return utf8nlookup(data, hangul, s, (size_t)-1);
 }
 
 /*
@@ -270,11 +409,13 @@ int utf8agemax(const struct utf8data *data, const char *s)
 	utf8leaf_t	*leaf;
 	int		age = 0;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
+
 	while (*s) {
-		leaf = utf8lookup(data, s);
+		leaf = utf8lookup(data, hangul, s);
 		if (!leaf)
 			return -1;
 
@@ -297,12 +438,13 @@ int utf8agemin(const struct utf8data *data, const char *s)
 	utf8leaf_t	*leaf;
 	int		age;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
 	age = data->maxage;
 	while (*s) {
-		leaf = utf8lookup(data, s);
+		leaf = utf8lookup(data, hangul, s);
 		if (!leaf)
 			return -1;
 		leaf_age = utf8agetab[LEAF_GEN(leaf)];
@@ -323,11 +465,13 @@ int utf8nagemax(const struct utf8data *data, const char *s, size_t len)
 	utf8leaf_t	*leaf;
 	int		age = 0;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
+
 	while (len && *s) {
-		leaf = utf8nlookup(data, s, len);
+		leaf = utf8nlookup(data, hangul, s, len);
 		if (!leaf)
 			return -1;
 		leaf_age = utf8agetab[LEAF_GEN(leaf)];
@@ -349,12 +493,13 @@ int utf8nagemin(const struct utf8data *data, const char *s, size_t len)
 	utf8leaf_t	*leaf;
 	int		leaf_age;
 	int		age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
 	age = data->maxage;
 	while (len && *s) {
-		leaf = utf8nlookup(data, s, len);
+		leaf = utf8nlookup(data, hangul, s, len);
 		if (!leaf)
 			return -1;
 		leaf_age = utf8agetab[LEAF_GEN(leaf)];
@@ -377,11 +522,12 @@ ssize_t utf8len(const struct utf8data *data, const char *s)
 {
 	utf8leaf_t	*leaf;
 	size_t		ret = 0;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
 	while (*s) {
-		leaf = utf8lookup(data, s);
+		leaf = utf8lookup(data, hangul, s);
 		if (!leaf)
 			return -1;
 		if (utf8agetab[LEAF_GEN(leaf)] > data->maxage)
@@ -404,11 +550,12 @@ ssize_t utf8nlen(const struct utf8data *data, const char *s, size_t len)
 {
 	utf8leaf_t	*leaf;
 	size_t		ret = 0;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!data)
 		return -1;
 	while (len && *s) {
-		leaf = utf8nlookup(data, s, len);
+		leaf = utf8nlookup(data, hangul, s, len);
 		if (!leaf)
 			return -1;
 		if (utf8agetab[LEAF_GEN(leaf)] > data->maxage)
@@ -531,10 +678,12 @@ int utf8byte(struct utf8cursor *u8c)
 		}
 
 		/* Look up the data for the current character. */
-		if (u8c->p)
-			leaf = utf8lookup(u8c->data, u8c->s);
-		else
-			leaf = utf8nlookup(u8c->data, u8c->s, u8c->len);
+		if (u8c->p) {
+			leaf = utf8lookup(u8c->data, u8c->hangul, u8c->s);
+		} else {
+			leaf = utf8nlookup(u8c->data, u8c->hangul,
+					   u8c->s, u8c->len);
+		}
 
 		/* No leaf found implies that the input is a binary blob. */
 		if (!leaf)
@@ -555,7 +704,9 @@ int utf8byte(struct utf8cursor *u8c)
 				ccc = STOPPER;
 				goto ccc_mismatch;
 			}
-			leaf = utf8lookup(u8c->data, u8c->s);
+
+			leaf = utf8lookup(u8c->data, u8c->hangul, u8c->s);
+			ccc = LEAF_CCC(leaf);
 		}
 
 		/*
diff --git a/fs/unicode/utf8n.h b/fs/unicode/utf8n.h
index 696e52124296..b63a9091dc39 100644
--- a/fs/unicode/utf8n.h
+++ b/fs/unicode/utf8n.h
@@ -76,6 +76,9 @@ extern int utf8nagemin(const struct utf8data *data, const char *s, size_t len);
 extern ssize_t utf8len(const struct utf8data *data, const char *s);
 extern ssize_t utf8nlen(const struct utf8data *data, const char *s, size_t len);
 
+/* Needed in struct utf8cursor below. */
+#define UTF8HANGULLEAF	(12)
+
 /*
  * Cursor structure used by the normalizer.
  */
@@ -89,6 +92,7 @@ struct utf8cursor {
 	unsigned int	slen;
 	short int	ccc;
 	short int	nccc;
+	unsigned char	hangul[UTF8HANGULLEAF];
 };
 
 /*
diff --git a/scripts/mkutf8data.c b/scripts/mkutf8data.c
index 4df1a799f73c..12ce94b43be6 100644
--- a/scripts/mkutf8data.c
+++ b/scripts/mkutf8data.c
@@ -182,10 +182,14 @@ typedef unsigned char utf8leaf_t;
 #define MAXCCC		(254)
 #define STOPPER		(0)
 #define DECOMPOSE	(255)
+#define HANGUL		((char)(255))
+
+#define UTF8HANGULLEAF	(12)
 
 struct tree;
-static utf8leaf_t *utf8nlookup(struct tree *, const char *, size_t);
-static utf8leaf_t *utf8lookup(struct tree *, const char *);
+static utf8leaf_t *utf8nlookup(struct tree *, unsigned char *,
+			       const char *, size_t);
+static utf8leaf_t *utf8lookup(struct tree *, unsigned char *, const char *);
 
 unsigned char *utf8data;
 size_t utf8data_size;
@@ -333,6 +337,8 @@ static int utf32valid(unsigned int unichar)
 	return unichar < 0x110000;
 }
 
+#define HANGUL_SYLLABLE(U)	((U) >= 0xAC00 && (U) <= 0xD7A3)
+
 #define NODE 1
 #define LEAF 0
 
@@ -463,7 +469,7 @@ static void tree_walk(struct tree *tree)
 								 indent+1);
 						leaves += 1;
 					} else if (node->right) {
-						assert(node->rightnode==NODE);
+						assert(node->rightnode == NODE);
 						indent += 1;
 						node = node->right;
 						break;
@@ -857,7 +863,7 @@ static void mark_nodes(struct tree *tree)
 					}
 				}
 			} else if (node->right) {
-				assert(node->rightnode==NODE);
+				assert(node->rightnode == NODE);
 				node = node->right;
 				continue;
 			}
@@ -909,7 +915,7 @@ static void mark_nodes(struct tree *tree)
 					}
 				}
 			} else if (node->right) {
-				assert(node->rightnode==NODE);
+				assert(node->rightnode == NODE);
 				node = node->right;
 				if (!node->mark && node->parent->mark &&
 				    !node->parent->left) {
@@ -992,7 +998,7 @@ static int index_nodes(struct tree *tree, int index)
 					index += tree->leaf_size(node->right);
 					count++;
 				} else if (node->right) {
-					assert(node->rightnode==NODE);
+					assert(node->rightnode == NODE);
 					indent += 1;
 					node = node->right;
 					break;
@@ -1013,6 +1019,25 @@ static int index_nodes(struct tree *tree, int index)
 	return index;
 }
 
+/*
+ * Mark the nodes in a subtree, helper for size_nodes().
+ */
+static int mark_subtree(struct node *node)
+{
+	int changed;
+
+	if (!node || node->mark)
+		return 0;
+	node->mark = 1;
+	node->index = node->parent->index;
+	changed = 1;
+	if (node->leftnode == NODE)
+		changed += mark_subtree(node->left);
+	if (node->rightnode == NODE)
+		changed += mark_subtree(node->right);
+	return changed;
+}
+
 /*
  * Compute the size of nodes and leaves. We start by assuming that
  * each node needs to store a three-byte offset. The indexes of the
@@ -1031,6 +1056,7 @@ static int size_nodes(struct tree *tree)
 	unsigned int bitmask;
 	unsigned int pathbits;
 	unsigned int pathmask;
+	unsigned int nbit;
 	int changed;
 	int offset;
 	int size;
@@ -1058,22 +1084,40 @@ static int size_nodes(struct tree *tree)
 			size = 1;
 		} else {
 			if (node->rightnode == NODE) {
+				/*
+				 * If the right node is not marked,
+				 * look for a corresponding node in
+				 * the next tree.  Such a node need
+				 * not exist.
+				 */
 				right = node->right;
 				next = tree->next;
 				while (!right->mark) {
 					assert(next);
 					n = next->root;
 					while (n->bitnum != node->bitnum) {
-						if (pathbits & (1<<n->bitnum))
+						nbit = 1 << n->bitnum;
+						if (!(pathmask & nbit))
+							break;
+						if (pathbits & nbit) {
+							if (n->rightnode == LEAF)
+								break;
 							n = n->right;
-						else
+						} else {
+							if (n->leftnode == LEAF)
+								break;
 							n = n->left;
+						}
 					}
+					if (n->bitnum != node->bitnum)
+						break;
 					n = n->right;
-					assert(right->bitnum == n->bitnum);
 					right = n;
 					next = next->next;
 				}
+				/* Make sure the right node is marked. */
+				if (!right->mark)
+					changed += mark_subtree(right);
 				offset = right->index - node->index;
 			} else {
 				offset = *tree->leaf_index(tree, node->right);
@@ -1115,7 +1159,7 @@ static int size_nodes(struct tree *tree)
 				if (node->rightnode == LEAF) {
 					assert(node->right);
 				} else if (node->right) {
-					assert(node->rightnode==NODE);
+					assert(node->rightnode == NODE);
 					indent += 1;
 					node = node->right;
 					break;
@@ -1148,8 +1192,15 @@ static void emit(struct tree *tree, unsigned char *data)
 	int offset;
 	int index;
 	int indent;
+	int size;
+	int bytes;
+	int leaves;
+	int nodes[4];
 	unsigned char byte;
 
+	nodes[0] = nodes[1] = nodes[2] = nodes[3] = 0;
+	leaves = 0;
+	bytes = 0;
 	index = tree->index;
 	data += index;
 	indent = 1;
@@ -1158,7 +1209,10 @@ static void emit(struct tree *tree, unsigned char *data)
 	if (tree->childnode == LEAF) {
 		assert(tree->root);
 		tree->leaf_emit(tree->root, data);
-		return;
+		size = tree->leaf_size(tree->root);
+		index += size;
+		leaves++;
+		goto done;
 	}
 
 	assert(tree->childnode == NODE);
@@ -1185,6 +1239,7 @@ static void emit(struct tree *tree, unsigned char *data)
 				offlen = 2;
 			else
 				offlen = 3;
+			nodes[offlen]++;
 			offset = node->offset;
 			byte |= offlen << OFFLEN_SHIFT;
 			*data++ = byte;
@@ -1197,12 +1252,14 @@ static void emit(struct tree *tree, unsigned char *data)
 		} else if (node->left) {
 			if (node->leftnode == NODE)
 				byte |= TRIENODE;
+			nodes[0]++;
 			*data++ = byte;
 			index++;
 		} else if (node->right) {
 			byte |= RIGHTNODE;
 			if (node->rightnode == NODE)
 				byte |= TRIENODE;
+			nodes[0]++;
 			*data++ = byte;
 			index++;
 		} else {
@@ -1217,7 +1274,10 @@ static void emit(struct tree *tree, unsigned char *data)
 					assert(node->left);
 					data = tree->leaf_emit(node->left,
 							       data);
-					index += tree->leaf_size(node->left);
+					size = tree->leaf_size(node->left);
+					index += size;
+					bytes += size;
+					leaves++;
 				} else if (node->left) {
 					assert(node->leftnode == NODE);
 					indent += 1;
@@ -1231,9 +1291,12 @@ static void emit(struct tree *tree, unsigned char *data)
 					assert(node->right);
 					data = tree->leaf_emit(node->right,
 							       data);
-					index += tree->leaf_size(node->right);
+					size = tree->leaf_size(node->right);
+					index += size;
+					bytes += size;
+					leaves++;
 				} else if (node->right) {
-					assert(node->rightnode==NODE);
+					assert(node->rightnode == NODE);
 					indent += 1;
 					node = node->right;
 					break;
@@ -1245,6 +1308,15 @@ static void emit(struct tree *tree, unsigned char *data)
 			indent -= 1;
 		}
 	}
+done:
+	if (verbose > 0) {
+		printf("Emitted %d (%d) leaves",
+			leaves, bytes);
+		printf(" %d (%d+%d+%d+%d) nodes",
+			nodes[0] + nodes[1] + nodes[2] + nodes[3],
+			nodes[0], nodes[1], nodes[2], nodes[3]);
+		printf(" %d total\n", index - tree->index);
+	}
 }
 
 /* ------------------------------------------------------------------ */
@@ -1346,8 +1418,12 @@ static void nfdi_print(void *l, int indent)
 
 	printf("%*sleaf @ %p code %X ccc %d gen %d", indent, "", leaf,
 		leaf->code, leaf->ccc, leaf->gen);
-	if (leaf->utf8nfdi)
+
+	if (leaf->utf8nfdi && leaf->utf8nfdi[0] == HANGUL)
+		printf(" nfdi \"%s\"", "HANGUL SYLLABLE");
+	else if (leaf->utf8nfdi)
 		printf(" nfdi \"%s\"", (const char*)leaf->utf8nfdi);
+
 	printf("\n");
 }
 
@@ -1357,8 +1433,11 @@ static void nfdicf_print(void *l, int indent)
 
 	printf("%*sleaf @ %p code %X ccc %d gen %d", indent, "", leaf,
 		leaf->code, leaf->ccc, leaf->gen);
+
 	if (leaf->utf8nfdicf)
 		printf(" nfdicf \"%s\"", (const char*)leaf->utf8nfdicf);
+	else if (leaf->utf8nfdi && leaf->utf8nfdi[0] == HANGUL)
+		printf(" nfdi \"%s\"", "HANGUL SYLLABLE");
 	else if (leaf->utf8nfdi)
 		printf(" nfdi \"%s\"", (const char*)leaf->utf8nfdi);
 	printf("\n");
@@ -1388,9 +1467,11 @@ static int correction_mark(void *l)
 static int nfdi_size(void *l)
 {
 	struct unicode_data *leaf = l;
-
 	int size = 2;
-	if (leaf->utf8nfdi)
+
+	if (HANGUL_SYLLABLE(leaf->code))
+		size += 1;
+	else if (leaf->utf8nfdi)
 		size += strlen(leaf->utf8nfdi) + 1;
 	return size;
 }
@@ -1398,9 +1479,11 @@ static int nfdi_size(void *l)
 static int nfdicf_size(void *l)
 {
 	struct unicode_data *leaf = l;
-
 	int size = 2;
-	if (leaf->utf8nfdicf)
+
+	if (HANGUL_SYLLABLE(leaf->code))
+		size += 1;
+	else if (leaf->utf8nfdicf)
 		size += strlen(leaf->utf8nfdicf) + 1;
 	else if (leaf->utf8nfdi)
 		size += strlen(leaf->utf8nfdi) + 1;
@@ -1427,7 +1510,11 @@ static unsigned char *nfdi_emit(void *l, unsigned char *data)
 	unsigned char *s;
 
 	*data++ = leaf->gen;
-	if (leaf->utf8nfdi) {
+
+	if (HANGUL_SYLLABLE(leaf->code)) {
+		*data++ = DECOMPOSE;
+		*data++ = HANGUL;
+	} else if (leaf->utf8nfdi) {
 		*data++ = DECOMPOSE;
 		s = (unsigned char*)leaf->utf8nfdi;
 		while ((*data++ = *s++) != 0)
@@ -1444,7 +1531,11 @@ static unsigned char *nfdicf_emit(void *l, unsigned char *data)
 	unsigned char *s;
 
 	*data++ = leaf->gen;
-	if (leaf->utf8nfdicf) {
+
+	if (HANGUL_SYLLABLE(leaf->code)) {
+		*data++ = DECOMPOSE;
+		*data++ = HANGUL;
+	} else if (leaf->utf8nfdicf) {
 		*data++ = DECOMPOSE;
 		s = (unsigned char*)leaf->utf8nfdicf;
 		while ((*data++ = *s++) != 0)
@@ -1467,6 +1558,11 @@ static void utf8_create(struct unicode_data *data)
 	unsigned int *um;
 	int i;
 
+	if (data->utf8nfdi) {
+		assert(data->utf8nfdi[0] == HANGUL);
+		return;
+	}
+
 	u = utf;
 	um = data->utf32nfdi;
 	if (um) {
@@ -1652,6 +1748,7 @@ static void verify(struct tree *tree)
 	utf8leaf_t	*leaf;
 	unsigned int	unichar;
 	char		key[4];
+	unsigned char	hangul[UTF8HANGULLEAF];
 	int		report;
 	int		nocf;
 
@@ -1665,7 +1762,8 @@ static void verify(struct tree *tree)
 		if (data->correction <= tree->maxage)
 			data = &unicode_data[unichar];
 		utf8encode(key,unichar);
-		leaf = utf8lookup(tree, key);
+		leaf = utf8lookup(tree, hangul, key);
+
 		if (!leaf) {
 			if (data->gen != -1)
 				report++;
@@ -1679,7 +1777,10 @@ static void verify(struct tree *tree)
 			if (data->gen != LEAF_GEN(leaf))
 				report++;
 			if (LEAF_CCC(leaf) == DECOMPOSE) {
-				if (nocf) {
+				if (HANGUL_SYLLABLE(data->code)) {
+					if (data->utf8nfdi[0] != HANGUL)
+						report++;
+				} else if (nocf) {
 					if (!data->utf8nfdi) {
 						report++;
 					} else if (strcmp(data->utf8nfdi,
@@ -2323,8 +2424,7 @@ static void corrections_init(void)
  *
  */
 
-static void
-hangul_decompose(void)
+static void hangul_decompose(void)
 {
 	unsigned int sb = 0xAC00;
 	unsigned int lb = 0x1100;
@@ -2368,6 +2468,15 @@ hangul_decompose(void)
 		memcpy(um, mapping, i * sizeof(unsigned int));
 		unicode_data[unichar].utf32nfdicf = um;
 
+		/*
+		 * Add a cookie as a reminder that the hangul syllable
+		 * decompositions must not be stored in the generated
+		 * trie.
+		 */
+		unicode_data[unichar].utf8nfdi = malloc(2);
+		unicode_data[unichar].utf8nfdi[0] = HANGUL;
+		unicode_data[unichar].utf8nfdi[1] = '\0';
+
 		if (verbose > 1)
 			print_utf32nfdi(unichar);
 
@@ -2493,6 +2602,99 @@ int utf8cursor(struct utf8cursor *, struct tree *, const char *);
 int utf8ncursor(struct utf8cursor *, struct tree *, const char *, size_t);
 int utf8byte(struct utf8cursor *);
 
+/*
+ * Hangul decomposition (algorithm from Section 3.12 of Unicode 6.3.0)
+ *
+ * AC00;<Hangul Syllable, First>;Lo;0;L;;;;;N;;;;;
+ * D7A3;<Hangul Syllable, Last>;Lo;0;L;;;;;N;;;;;
+ *
+ * SBase = 0xAC00
+ * LBase = 0x1100
+ * VBase = 0x1161
+ * TBase = 0x11A7
+ * LCount = 19
+ * VCount = 21
+ * TCount = 28
+ * NCount = 588 (VCount * TCount)
+ * SCount = 11172 (LCount * NCount)
+ *
+ * Decomposition:
+ *   SIndex = s - SBase
+ *
+ * LV (Canonical/Full)
+ *   LIndex = SIndex / NCount
+ *   VIndex = (Sindex % NCount) / TCount
+ *   LPart = LBase + LIndex
+ *   VPart = VBase + VIndex
+ *
+ * LVT (Canonical)
+ *   LVIndex = (SIndex / TCount) * TCount
+ *   TIndex = (Sindex % TCount)
+ *   LVPart = SBase + LVIndex
+ *   TPart = TBase + TIndex
+ *
+ * LVT (Full)
+ *   LIndex = SIndex / NCount
+ *   VIndex = (Sindex % NCount) / TCount
+ *   TIndex = (Sindex % TCount)
+ *   LPart = LBase + LIndex
+ *   VPart = VBase + VIndex
+ *   if (TIndex == 0) {
+ *          d = <LPart, VPart>
+ *   } else {
+ *          TPart = TBase + TIndex
+ *          d = <LPart, VPart, TPart>
+ *   }
+ */
+
+/* Constants */
+#define SB	(0xAC00)
+#define LB	(0x1100)
+#define VB	(0x1161)
+#define TB	(0x11A7)
+#define LC	(19)
+#define VC	(21)
+#define TC	(28)
+#define NC	(VC * TC)
+#define SC	(LC * NC)
+
+/* Algorithmic decomposition of hangul syllable. */
+static utf8leaf_t *utf8hangul(const char *str, unsigned char *hangul)
+{
+	unsigned int	si;
+	unsigned int	li;
+	unsigned int	vi;
+	unsigned int	ti;
+	unsigned char	*h;
+
+	/* Calculate the SI, LI, VI, and TI values. */
+	si = utf8decode(str) - SB;
+	li = si / NC;
+	vi = (si % NC) / TC;
+	ti = si % TC;
+
+	/* Fill in base of leaf. */
+	h = hangul;
+	LEAF_GEN(h) = 2;
+	LEAF_CCC(h) = DECOMPOSE;
+	h += 2;
+
+	/* Add LPart, a 3-byte UTF-8 sequence. */
+	h += utf8encode((char *)h, li + LB);
+
+	/* Add VPart, a 3-byte UTF-8 sequence. */
+	h += utf8encode((char *)h, vi + VB);
+
+	/* Add TPart if required, also a 3-byte UTF-8 sequence. */
+	if (ti)
+		h += utf8encode((char *)h, ti + TB);
+
+	/* Terminate string. */
+	h[0] = '\0';
+
+	return hangul;
+}
+
 /*
  * Use trie to scan s, touching at most len bytes.
  * Returns the leaf if one exists, NULL otherwise.
@@ -2501,7 +2703,8 @@ int utf8byte(struct utf8cursor *);
  * is well-formed and corresponds to a known unicode code point.  The
  * shorthand for this will be "is valid UTF-8 unicode".
  */
-static utf8leaf_t *utf8nlookup(struct tree *tree, const char *s, size_t len)
+static utf8leaf_t *utf8nlookup(struct tree *tree, unsigned char *hangul,
+			       const char *s, size_t len)
 {
 	utf8trie_t	*trie = utf8data + tree->index;
 	int		offlen;
@@ -2557,6 +2760,14 @@ static utf8leaf_t *utf8nlookup(struct tree *tree, const char *s, size_t len)
 			}
 		}
 	}
+	/*
+	 * Hangul decomposition is done algorithmically. These are the
+	 * codepoints >= 0xAC00 and <= 0xD7A3. Their UTF-8 encoding is
+	 * always 3 bytes long, so s has been advanced twice, and the
+	 * start of the sequence is at s-2.
+	 */
+	if (LEAF_CCC(trie) == DECOMPOSE && LEAF_STR(trie)[0] == HANGUL)
+		trie = utf8hangul(s - 2, hangul);
 	return trie;
 }
 
@@ -2566,9 +2777,10 @@ static utf8leaf_t *utf8nlookup(struct tree *tree, const char *s, size_t len)
  *
  * Forwards to trie_nlookup().
  */
-static utf8leaf_t *utf8lookup(struct tree *tree, const char *s)
+static utf8leaf_t *utf8lookup(struct tree *tree, unsigned char *hangul,
+			      const char *s)
 {
-	return utf8nlookup(tree, s, (size_t)-1);
+	return utf8nlookup(tree, hangul, s, (size_t)-1);
 }
 
 /*
@@ -2592,11 +2804,14 @@ int utf8agemax(struct tree *tree, const char *s)
 	utf8leaf_t	*leaf;
 	int		age = 0;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
+
 	while (*s) {
-		if (!(leaf = utf8lookup(tree, s)))
+		leaf = utf8lookup(tree, hangul, s);
+		if (!leaf)
 			return -1;
 		leaf_age = ages[LEAF_GEN(leaf)];
 		if (leaf_age <= tree->maxage && leaf_age > age)
@@ -2616,12 +2831,14 @@ int utf8agemin(struct tree *tree, const char *s)
 	utf8leaf_t	*leaf;
 	int		age;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
 	age = tree->maxage;
 	while (*s) {
-		if (!(leaf = utf8lookup(tree, s)))
+		leaf = utf8lookup(tree, hangul, s);
+		if (!leaf)
 			return -1;
 		leaf_age = ages[LEAF_GEN(leaf)];
 		if (leaf_age <= tree->maxage && leaf_age < age)
@@ -2640,11 +2857,14 @@ int utf8nagemax(struct tree *tree, const char *s, size_t len)
 	utf8leaf_t	*leaf;
 	int		age = 0;
 	int		leaf_age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
+
         while (len && *s) {
-		if (!(leaf = utf8nlookup(tree, s, len)))
+		leaf = utf8nlookup(tree, hangul, s, len);
+		if (!leaf)
 			return -1;
 		leaf_age = ages[LEAF_GEN(leaf)];
 		if (leaf_age <= tree->maxage && leaf_age > age)
@@ -2664,12 +2884,14 @@ int utf8nagemin(struct tree *tree, const char *s, size_t len)
 	utf8leaf_t	*leaf;
 	int		leaf_age;
 	int		age;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
 	age = tree->maxage;
         while (len && *s) {
-		if (!(leaf = utf8nlookup(tree, s, len)))
+		leaf = utf8nlookup(tree, hangul, s, len);
+		if (!leaf)
 			return -1;
 		leaf_age = ages[LEAF_GEN(leaf)];
 		if (leaf_age <= tree->maxage && leaf_age < age)
@@ -2690,11 +2912,13 @@ ssize_t utf8len(struct tree *tree, const char *s)
 {
 	utf8leaf_t	*leaf;
 	size_t		ret = 0;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
 	while (*s) {
-		if (!(leaf = utf8lookup(tree, s)))
+		leaf = utf8lookup(tree, hangul, s);
+		if (!leaf)
 			return -1;
 		if (ages[LEAF_GEN(leaf)] > tree->maxage)
 			ret += utf8clen(s);
@@ -2715,11 +2939,13 @@ ssize_t utf8nlen(struct tree *tree, const char *s, size_t len)
 {
 	utf8leaf_t	*leaf;
 	size_t		ret = 0;
+	unsigned char	hangul[UTF8HANGULLEAF];
 
 	if (!tree)
 		return -1;
 	while (len && *s) {
-		if (!(leaf = utf8nlookup(tree, s, len)))
+		leaf = utf8nlookup(tree, hangul, s, len);
+		if (!leaf)
 			return -1;
 		if (ages[LEAF_GEN(leaf)] > tree->maxage)
 			ret += utf8clen(s);
@@ -2747,6 +2973,7 @@ struct utf8cursor {
 	short int	ccc;
 	short int	nccc;
 	unsigned int	unichar;
+	unsigned char	hangul[UTF8HANGULLEAF];
 };
 
 /*
@@ -2854,10 +3081,12 @@ int utf8byte(struct utf8cursor *u8c)
 		}
 
 		/* Look up the data for the current character. */
-		if (u8c->p)
-			leaf = utf8lookup(u8c->tree, u8c->s);
-		else
-			leaf = utf8nlookup(u8c->tree, u8c->s, u8c->len);
+		if (u8c->p) {
+			leaf = utf8lookup(u8c->tree, u8c->hangul, u8c->s);
+		} else {
+			leaf = utf8nlookup(u8c->tree, u8c->hangul,
+					   u8c->s, u8c->len);
+		}
 
 		/* No leaf found implies that the input is a binary blob. */
 		if (!leaf)
@@ -2877,7 +3106,7 @@ int utf8byte(struct utf8cursor *u8c)
 				ccc = STOPPER;
 				goto ccc_mismatch;
 			}
-			leaf = utf8lookup(u8c->tree, u8c->s);
+			leaf = utf8lookup(u8c->tree, u8c->hangul, u8c->s);
 			ccc = LEAF_CCC(leaf);
 		}
 		u8c->unichar = utf8decode(u8c->s);
-- 
2.20.1

