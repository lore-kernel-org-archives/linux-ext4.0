From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v2 06/13] charsets: utf8: reduce the size of utf8data[]
Date: Thu, 25 Jan 2018 00:53:42 -0200
Message-ID: <20180125025349.31494-7-krisman@collabora.co.uk>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        alvaro.soliverez@collabora.co.uk, kernel@lists.collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, olaf@sgi.com,
        viro@zeniv.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180125025349.31494-1-krisman@collabora.co.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
 include/linux/utf8norm.h |   4 +
 lib/charsets/utf8norm.c  | 191 ++++++++++++++++++++++++++----
 scripts/mkutf8data.c     | 295 +++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 435 insertions(+), 55 deletions(-)

diff --git a/include/linux/utf8norm.h b/include/linux/utf8norm.h
index 0f5fc14d4fd2..f60827663503 100644
--- a/include/linux/utf8norm.h
+++ b/include/linux/utf8norm.h
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
diff --git a/lib/charsets/utf8norm.c b/lib/charsets/utf8norm.c
index c225a13f6eea..8cd389c38f2b 100644
--- a/lib/charsets/utf8norm.c
+++ b/lib/charsets/utf8norm.c
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
diff --git a/scripts/mkutf8data.c b/scripts/mkutf8data.c
index 700b41c0cb66..69f3be92ba71 100644
--- a/scripts/mkutf8data.c
+++ b/scripts/mkutf8data.c
@@ -180,10 +180,14 @@ typedef unsigned char utf8leaf_t;
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
@@ -334,6 +338,8 @@ utf32valid(unsigned int unichar)
 	return unichar < 0x110000;
 }
 
+#define HANGUL_SYLLABLE(U)	((U) >= 0xAC00 && (U) <= 0xD7A3)
+
 #define NODE 1
 #define LEAF 0
 
@@ -466,7 +472,7 @@ tree_walk(struct tree *tree)
 								 indent+1);
 						leaves += 1;
 					} else if (node->right) {
-						assert(node->rightnode==NODE);
+						assert(node->rightnode == NODE);
 						indent += 1;
 						node = node->right;
 						break;
@@ -864,7 +870,7 @@ mark_nodes(struct tree *tree)
 					}
 				}
 			} else if (node->right) {
-				assert(node->rightnode==NODE);
+				assert(node->rightnode == NODE);
 				node = node->right;
 				continue;
 			}
@@ -916,7 +922,7 @@ mark_nodes(struct tree *tree)
 					}
 				}
 			} else if (node->right) {
-				assert(node->rightnode==NODE);
+				assert(node->rightnode == NODE);
 				node = node->right;
 				if (!node->mark && node->parent->mark &&
 				    !node->parent->left) {
@@ -1000,7 +1006,7 @@ index_nodes(struct tree *tree, int index)
 					index += tree->leaf_size(node->right);
 					count++;
 				} else if (node->right) {
-					assert(node->rightnode==NODE);
+					assert(node->rightnode == NODE);
 					indent += 1;
 					node = node->right;
 					break;
@@ -1021,6 +1027,26 @@ index_nodes(struct tree *tree, int index)
 	return index;
 }
 
+/*
+ * Mark the nodes in a subtree, helper for size_nodes().
+ */
+static int
+mark_subtree(struct node *node)
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
@@ -1040,6 +1066,7 @@ size_nodes(struct tree *tree)
 	unsigned int bitmask;
 	unsigned int pathbits;
 	unsigned int pathmask;
+	unsigned int nbit;
 	int changed;
 	int offset;
 	int size;
@@ -1067,22 +1094,40 @@ size_nodes(struct tree *tree)
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
@@ -1124,7 +1169,7 @@ size_nodes(struct tree *tree)
 				if (node->rightnode == LEAF) {
 					assert(node->right);
 				} else if (node->right) {
-					assert(node->rightnode==NODE);
+					assert(node->rightnode == NODE);
 					indent += 1;
 					node = node->right;
 					break;
@@ -1158,8 +1203,15 @@ emit(struct tree *tree, unsigned char *data)
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
@@ -1168,7 +1220,10 @@ emit(struct tree *tree, unsigned char *data)
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
@@ -1195,6 +1250,7 @@ emit(struct tree *tree, unsigned char *data)
 				offlen = 2;
 			else
 				offlen = 3;
+			nodes[offlen]++;
 			offset = node->offset;
 			byte |= offlen << OFFLEN_SHIFT;
 			*data++ = byte;
@@ -1207,12 +1263,14 @@ emit(struct tree *tree, unsigned char *data)
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
@@ -1227,7 +1285,10 @@ emit(struct tree *tree, unsigned char *data)
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
@@ -1241,9 +1302,12 @@ emit(struct tree *tree, unsigned char *data)
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
@@ -1255,6 +1319,15 @@ emit(struct tree *tree, unsigned char *data)
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
@@ -1360,7 +1433,9 @@ nfkdi_print(void *l, int indent)
 
 	printf("%*sleaf @ %p code %X ccc %d gen %d", indent, "", leaf,
 		leaf->code, leaf->ccc, leaf->gen);
-	if (leaf->utf8nfkdi)
+	if (leaf->utf8nfkdi && leaf->utf8nfkdi[0] == HANGUL)
+		printf(" nfkdi \"%s\"", "HANGUL SYLLABLE");
+	else if (leaf->utf8nfkdi)
 		printf(" nfkdi \"%s\"", (const char*)leaf->utf8nfkdi);
 	printf("\n");
 }
@@ -1374,6 +1449,8 @@ nfkdicf_print(void *l, int indent)
 		leaf->code, leaf->ccc, leaf->gen);
 	if (leaf->utf8nfkdicf)
 		printf(" nfkdicf \"%s\"", (const char*)leaf->utf8nfkdicf);
+	else if (leaf->utf8nfkdi && leaf->utf8nfkdi[0] == HANGUL)
+		printf(" nfkdi \"%s\"", "HANGUL SYLLABLE");
 	else if (leaf->utf8nfkdi)
 		printf(" nfkdi \"%s\"", (const char*)leaf->utf8nfkdi);
 	printf("\n");
@@ -1409,7 +1486,9 @@ nfkdi_size(void *l)
 	struct unicode_data *leaf = l;
 
 	int size = 2;
-	if (leaf->utf8nfkdi)
+	if (HANGUL_SYLLABLE(leaf->code))
+		size += 1;
+	else if (leaf->utf8nfkdi)
 		size += strlen(leaf->utf8nfkdi) + 1;
 	return size;
 }
@@ -1420,7 +1499,9 @@ nfkdicf_size(void *l)
 	struct unicode_data *leaf = l;
 
 	int size = 2;
-	if (leaf->utf8nfkdicf)
+	if (HANGUL_SYLLABLE(leaf->code))
+		size += 1;
+	else if (leaf->utf8nfkdicf)
 		size += strlen(leaf->utf8nfkdicf) + 1;
 	else if (leaf->utf8nfkdi)
 		size += strlen(leaf->utf8nfkdi) + 1;
@@ -1450,7 +1531,10 @@ nfkdi_emit(void *l, unsigned char *data)
 	unsigned char *s;
 
 	*data++ = leaf->gen;
-	if (leaf->utf8nfkdi) {
+	if (HANGUL_SYLLABLE(leaf->code)) {
+		*data++ = DECOMPOSE;
+		*data++ = HANGUL;
+	} else if (leaf->utf8nfkdi) {
 		*data++ = DECOMPOSE;
 		s = (unsigned char*)leaf->utf8nfkdi;
 		while ((*data++ = *s++) != 0)
@@ -1468,7 +1552,10 @@ nfkdicf_emit(void *l, unsigned char *data)
 	unsigned char *s;
 
 	*data++ = leaf->gen;
-	if (leaf->utf8nfkdicf) {
+	if (HANGUL_SYLLABLE(leaf->code)) {
+		*data++ = DECOMPOSE;
+		*data++ = HANGUL;
+	} else if (leaf->utf8nfkdicf) {
 		*data++ = DECOMPOSE;
 		s = (unsigned char*)leaf->utf8nfkdicf;
 		while ((*data++ = *s++) != 0)
@@ -1492,6 +1579,11 @@ utf8_create(struct unicode_data *data)
 	unsigned int *um;
 	int i;
 
+	if (data->utf8nfkdi) {
+		assert(data->utf8nfkdi[0] == HANGUL);
+		return;
+	}
+
 	u = utf;
 	um = data->utf32nfkdi;
 	if (um) {
@@ -1682,6 +1774,7 @@ verify(struct tree *tree)
 	utf8leaf_t	*leaf;
 	unsigned int	unichar;
 	char		key[4];
+	unsigned char	hangul[UTF8HANGULLEAF];
 	int		report;
 	int		nocf;
 
@@ -1695,7 +1788,8 @@ verify(struct tree *tree)
 		if (data->correction <= tree->maxage)
 			data = &unicode_data[unichar];
 		utf8encode(key,unichar);
-		leaf = utf8lookup(tree, key);
+		leaf = utf8lookup(tree, hangul, key);
+
 		if (!leaf) {
 			if (data->gen != -1)
 				report++;
@@ -1709,7 +1803,10 @@ verify(struct tree *tree)
 			if (data->gen != LEAF_GEN(leaf))
 				report++;
 			if (LEAF_CCC(leaf) == DECOMPOSE) {
-				if (nocf) {
+				if (HANGUL_SYLLABLE(data->code)) {
+					if (data->utf8nfkdi[0] != HANGUL)
+						report++;
+				} else if (nocf) {
 					if (!data->utf8nfkdi) {
 						report++;
 					} else if (strcmp(data->utf8nfkdi,
@@ -2394,6 +2491,15 @@ hangul_decompose(void)
 		memcpy(um, mapping, i * sizeof(unsigned int));
 		unicode_data[unichar].utf32nfkdicf = um;
 
+		/*
+		 * Add a cookie as a reminder that the hangul syllable
+		 * decompositions must not be stored in the generated
+		 * trie.
+		 */
+		unicode_data[unichar].utf8nfkdi = malloc(2);
+		unicode_data[unichar].utf8nfkdi[0] = HANGUL;
+		unicode_data[unichar].utf8nfkdi[1] = '\0';
+
 		if (verbose > 1)
 			print_utf32nfkdi(unichar);
 
@@ -2521,6 +2627,100 @@ int utf8cursor(struct utf8cursor *, struct tree *, const char *);
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
@@ -2530,7 +2730,7 @@ int utf8byte(struct utf8cursor *);
  * shorthand for this will be "is valid UTF-8 unicode".
  */
 static utf8leaf_t *
-utf8nlookup(struct tree *tree, const char *s, size_t len)
+utf8nlookup(struct tree *tree, unsigned char *hangul, const char *s, size_t len)
 {
 	utf8trie_t	*trie = utf8data + tree->index;
 	int		offlen;
@@ -2586,6 +2786,14 @@ utf8nlookup(struct tree *tree, const char *s, size_t len)
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
 
@@ -2596,9 +2804,9 @@ utf8nlookup(struct tree *tree, const char *s, size_t len)
  * Forwards to trie_nlookup().
  */
 static utf8leaf_t *
-utf8lookup(struct tree *tree, const char *s)
+utf8lookup(struct tree *tree, unsigned char *hangul, const char *s)
 {
-	return utf8nlookup(tree, s, (size_t)-1);
+	return utf8nlookup(tree, hangul, s, (size_t)-1);
 }
 
 /*
@@ -2624,11 +2832,14 @@ utf8agemax(struct tree *tree, const char *s)
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
@@ -2649,12 +2860,14 @@ utf8agemin(struct tree *tree, const char *s)
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
@@ -2674,11 +2887,14 @@ utf8nagemax(struct tree *tree, const char *s, size_t len)
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
@@ -2699,12 +2915,14 @@ utf8nagemin(struct tree *tree, const char *s, size_t len)
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
@@ -2726,11 +2944,13 @@ utf8len(struct tree *tree, const char *s)
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
@@ -2752,11 +2972,13 @@ utf8nlen(struct tree *tree, const char *s, size_t len)
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
@@ -2784,6 +3006,7 @@ struct utf8cursor {
 	short int	ccc;
 	short int	nccc;
 	unsigned int	unichar;
+	unsigned char	hangul[UTF8HANGULLEAF];
 };
 
 /*
@@ -2900,10 +3123,12 @@ utf8byte(struct utf8cursor *u8c)
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
@@ -2923,7 +3148,7 @@ utf8byte(struct utf8cursor *u8c)
 				ccc = STOPPER;
 				goto ccc_mismatch;
 			}
-			leaf = utf8lookup(u8c->tree, u8c->s);
+			leaf = utf8lookup(u8c->tree, u8c->hangul, u8c->s);
 			ccc = LEAF_CCC(leaf);
 		}
 		u8c->unichar = utf8decode(u8c->s);
-- 
2.15.1
