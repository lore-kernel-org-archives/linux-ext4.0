From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC 2/2] ext4 btree basic implementation
Date: Tue, 23 Jun 2015 16:02:27 -0700
Message-ID: <20150623230227.GB10037@birch.djwong.org>
References: <1435029878-4517-1-git-send-email-mingming.cao@oracle.com>
 <1435029878-4517-3-git-send-email-mingming.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: mingming cao <mingming.cao@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45134 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933888AbbFWXCb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2015 19:02:31 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t5NN2UiD006504
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 23:02:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t5NN2Twj008972
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 23:02:29 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t5NN2Smg030829
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 23:02:29 GMT
Content-Disposition: inline
In-Reply-To: <1435029878-4517-3-git-send-email-mingming.cao@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 22, 2015 at 08:24:38PM -0700, mingming cao wrote:
> ---
>  ext4_btree.c | 1356 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 1356 insertions(+)
>  create mode 100644 ext4_btree.c
> 
> diff --git a/ext4_btree.c b/ext4_btree.c
> new file mode 100644
> index 0000000..baf253c
> --- /dev/null
> +++ b/ext4_btree.c
> @@ -0,0 +1,1356 @@
> +/*
> + * copyright (C) 2015 Oracle.  All rights reserved.

(Nit-picking, but this should be a capital-C "Copyright")

> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +
> +
> +
> +#include "ext4_btree.h"
> +
> +/*
> + * Calculate offset of the n-th key in a btree node.
> + */
> +static inline unsigned int
> +ext4_btree_key_offset(struct ext4_btree_geo *geo, unsigned int n)
> +{
> +	return geo->header_len + n * geo->key_len;

Parentheses around the multiplicative terms would make this a little easier
to scan a line for which variables go together, i.e.

return geo->header_len + (n * geo->key_len);

(Still, a minor nit.)

> +}
> +
> +/*
> + * Calculate offset of the n-th node pointer in a btree node.
> + */
> +static inline unsigned int
> +ext4_btree_val_offset(struct ext4_btree_geo *geo, unsigned int n)
> +{
> +	return geo->header_len +
> +		geo->max_pairs * geo->key_len +
> +		n * geo->val_len;
> +}
> +
> +/*
> + * Calculate offset of the n-th record in a btree leaf node.
> + */
> +static inline unsigned int
> +ext4_btree_rec_offset(struct ext4_btree_geo *geo, unsigned int n)
> +{
> +	return geo->header_len + n * geo->rec_len;
> +}
> +
> +/*
> + * Node header access functions
> + */
> +static inline struct ext4_btree_header*
> +ext4_btree_header_addr(struct ext4_btree_node *block)
> +{
> +	return (struct ext4_btree_header *)block;
> +}
> +
> +static inline unsigned int 
> +ext4_btree_get_numkeys(struct ext4_btree_node *node)
> +{
> +	return ext4_btree_header_addr(node)->btree_numkeys;
> +}
> +
> +static inline void
> +ext4_btree_update_numkeys(struct ext4_btree_node *node, unsigned int n)
> +{
> +	ext4_btree_header_addr(node)->btree_numkeys = n;
> +}
> +
> +static inline unsigned int 
> +ext4_btree_get_numrecs(struct ext4_btree_node *node)
> +{
> +	return ext4_btree_header_addr(node)->btree_numkeys;
> +}
> +
> +static inline void
> +ext4_btree_update_numrecs(struct ext4_btree_node *node, unsigned int n)
> +{
> +	ext4_btree_header_addr(node)->btree_numkeys = n;
> +}
> +
> +static inline unsigned int 
> +ext4_btree_get_level(struct ext4_btree_node *node)
> +{
> +	return ext4_btree_header_addr(node)->btree_level;
> +}
> +
> +static inline void 
> +ext4_btree_update_level(struct ext4_btree_node *node, unsigned int level)
> +{
> +	ext4_btree_header_addr(node)->btree_level = level;
> +}
> +
> +static inline unsigned long long 
> +ext4_btree_get_blockno(struct ext4_btree_node *node)
> +{
> +	return ext4_btree_header_addr(node)->btree_blockno;
> +}
> +
> +static inline void 
> +ext4_btree_update_blockno(struct ext4_btree_node *node, 
> +			  unsigned long long blockno)
> +{
> +	ext4_btree_header_addr(node)->btree_blockno = blockno;
> +}
> +
> +/*
> +* Get n-th key address from btree node
> +*/
> +static struct ext4_btree_key*
> +ext4_btree_key_addr(struct ext4_btree_geo *geo,
> +		    struct ext4_btree_node * node,
> +		    unsigned int n)
> +{
> +	return (struct ext4_btree_key *)
> +		((unsigned char *)node + ext4_btree_key_offset(geo, n));
> +}
> +
> +/*
> + * Set n-th key from btree node
> + */
> +static void
> +ext4_btree_set_key(struct ext4_btree_geo *geo,
> +		   struct ext4_btree_node *node, 
> +		   unsigned int n,
> +		   struct ext4_btree_key *key)
> +{
> +	struct ext4_btree_key *keyoffset = ext4_btree_key_addr(geo, node, n);
> +	*keyoffset = *key;
> +}
> +
> +static void  
> +ext4_btree_clear_key(struct ext4_btree_key *key)
> +{
> +	key->blockno = 0;
> +}
> +
> +/*
> + * Get n-th val address from btree node
> + */
> +static struct ext4_btree_val*
> +ext4_btree_val_addr(struct ext4_btree_geo *geo,
> +	            struct ext4_btree_node *node,
> +		    unsigned int n)
> +{
> +	return (struct ext4_btree_val *)
> +		((unsigned char *)node + ext4_btree_val_offset(geo, n));
> +}
> +
> +/*
> + * Set n-th val from btree node
> + */
> +static void
> +ext4_btree_set_val(struct ext4_btree_geo *geo,
> +		   struct ext4_btree_node *node, 
> +		   unsigned int n,
> +		   struct ext4_btree_val *val)
> +{
> +	struct ext4_btree_val *valaddr = ext4_btree_val_addr(geo, node, n);
> +	*valaddr = *val;
> +}
> +
> +static void  
> +ext4_btree_clear_val(struct ext4_btree_val *val)
> +{
> +	val->blockno = 0;
> +}
> +
> +/*
> + * Get n-th record address from btree node
> + */
> +static struct ext4_btree_rec*
> +ext4_btree_rec_addr(struct ext4_btree_geo *geo,
> +		    struct ext4_btree_node *node,
> +		    unsigned int n)
> +{
> +	return (struct ext4_btree_rec *)
> +		((unsigned char *)node + ext4_btree_rec_offset(geo, n));
> +}
> +
> +
> +/*
> + * Set n-th value from btree node
> + */
> +static void
> +ext4_btree_set_rec(struct ext4_btree_geo *geo,
> +		   struct ext4_btree_node *node,
> +		   unsigned int n,
> +		   struct ext4_btree_rec *rec)
> +{
> +	struct ext4_btree_rec *rec_offset = ext4_btree_rec_addr(geo, node, n);
> +	*rec_offset = *rec;
> +}
> +
> +static void
> +ext4_btree_clear_rec(struct ext4_btree_rec *rec)
> +{
> +		rec->key.blockno = 0;
> +		rec->len = 0;
> +		rec->ref_count = 0;
> +}
> +
> +/*
> + * Initialize btree root node
> + */
> +
> +void
> +ext4_btree_root_init(struct ext4_btree_root *root,
> +		     struct ext4_btree_geo *geo)
> +{
> +	root->node = NULL;
> +	root->geo = (*geo);
> +}
> +
> +/*
> + * Initialize ref btree root node
> + */
> +void
> +ext4_ref_btree_init(struct ext4_btree_root *root)
> +{
> +	ext4_btree_root_init(root, &ref_btree_geo);
> +}
> +
> +/*
> + * Allocate a btree node
> + */
> +struct ext4_btree_node *
> +ext4_btree_node_alloc()
> +{
> +	return fs_alloc_btree_node();

I'm assuming this is defined somewhere in your test harness?

> +}
> +
> +/*
> + * Free a btree node
> + */
> +
> +void
> +ext4_btree_node_free( struct ext4_btree_node *node)
> +{
> +	fs_free_btree_node(node);
> +}
> +
> +/*
> + * Compare two btree keys. 
> + * Return 1 if key1 > key2. 
> + * Return 0 if key1 == key2. 
> + * Return -1 if key1 < key2.  
> + */
> +int
> +ext4_btree_key_comp(struct ext4_btree_geo *geo,
> +	struct ext4_btree_key *key1,
> +	struct ext4_btree_key *key2)
> +{
> +	if (key1->blockno < key2->blockno)
> +		return -1;
> +	else if (key1->blockno > key2->blockno)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +/*
> + * If specified key within record' range
> + * Return -1 if key < record's key 
> + * Return 0 if record has the key
> + * Return 1 if record's key + len < key
> + */
> +int
> +ext4_btree_rec_comp(struct ext4_btree_geo *geo,
> +		    struct ext4_btree_key *key,
> +		    struct ext4_btree_rec *rec)
> +{
> +	if (key->blockno < rec->key.blockno)
> +		return -1;
> +	else if ((rec->key.blockno + rec->len) <= key->blockno)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +/*
> + * Check if the given record has this key 
> + * Return 1 if record has this key within range 
> + * Return 0 if not
> + */
> +static inline int
> +ext4_btree_rec_has_key(struct ext4_btree_geo *geo,
> +		       struct ext4_btree_rec *rec,
> +		       struct ext4_btree_key *key)
> +{
> +	return ((rec->key.blockno <=  key->blockno) &&
> +		((rec->key.blockno + rec->len) > key->blockno));
> +}
> +
> +static inline void 
> +ext4_btree_set_search_path(struct ext4_btree_search_path * spath,
> +			   int level, 
> +			   struct ext4_btree_node * node,
> +			   int pos)
> +{
> +	if (spath) {
> +		spath->node[level] = node;
> +		spath->pos[level] = pos;
> +	}
> +}
> +
> +/* define the btree layout for refcount btree */
> +struct ext4_btree_geo ref_btree_geo = {
> +	EXT4_BTREE_NODESIZE,
> +	EXT4_BTREE_HEADER_SIZE,
> +	EXT4_BTREE_KEY_SIZE,
> +	EXT4_BTREE_VAL_SIZE,
> +	EXT4_BTREE_REC_SIZE,
> +	EXT4_BTREE_MAX_KEY_VAL_PAIRS,
> +	EXT4_BTREE_MAX_RECS
> +};
> +
> +/* remember the index btree node on the search path */
> +struct ext4_btree_search_path {
> +	struct ext4_btree_node * node[EXT4_BTREE_MAX_LEVELS];
> +	int	pos [EXT4_BTREE_MAX_LEVELS];
> +};
> +
> +
> +/*
> + * Initialize the search path
> + */
> +void 
> +ext4_btree_init_search_path (struct ext4_btree_search_path *spath)
> +{
> +	int i;
> +	for (i=0; i< EXT4_BTREE_MAX_LEVELS; i++) {
> +		spath->node[i] = NULL;
> +		spath->pos[i] = EXT4_BTREE_MAX_KEY_VAL_PAIRS;
> +	}
> +}
> +
> +
> +/*
> + * Debug function to print out the whole tree
> + */
> +
> +void 
> +ext4_btree_rec_node_print(struct ext4_btree_geo *geo,
> +			  struct ext4_btree_node *node)
> +{
> +	int i;
> +	struct ext4_btree_rec *rec;
> +	int num_recs;
> +	
> +	if (node == NULL)
> +		return;
> +	num_recs =  ext4_btree_get_numrecs(node);
> +	ext4_btree_trace("==rec== node in block %lld - level %d numrecs %d\n",
> +		ext4_btree_get_blockno(node),
> +		ext4_btree_get_level(node),
> +		ext4_btree_get_numrecs(node));
> +	for (i = 0; i < num_recs; i++) {
> +		rec = ext4_btree_rec_addr(geo, node, i);
> +		ext4_btree_trace("rec%d key 0x%llx len 0x%x refcount %d\n",
> +			i, rec->key.blockno, rec->len, rec->ref_count);
> +	}
> +}
> +
> +void 
> +ext4_btree_index_node_print(struct ext4_btree_geo *geo,
> +			    struct ext4_btree_node *node)
> +{
> +	int i;
> +	int num_keys;
> +	struct ext4_btree_key *key;
> +	struct ext4_btree_val *val;
> +
> +	num_keys =  ext4_btree_get_numkeys(node);
> +	ext4_btree_trace("--key-- node in block %lld - level %d numkeys %d\n",
> +		ext4_btree_get_blockno(node),
> +		ext4_btree_get_level(node),
> +		ext4_btree_get_numkeys(node));
> +	for (i = 0; i < num_keys; i++)	{
> +		key = ext4_btree_key_addr(geo, node, i);
> +		val = ext4_btree_val_addr(geo, node, i);
> +		ext4_btree_trace("pair%d key 0x%llx val 0x%llx\n",
> +			i, key->blockno, val->blockno);
> +	}
> +}
> +
> +void 
> +ext4_btree_print(struct ext4_btree_root *root)
> +{
> +	struct ext4_btree_search_path spath;
> +	struct ext4_btree_node * node;
> +	struct ext4_btree_val * val;
> +	int level;
> +	int rootlevel;
> +	int pos;
> +	int numkeys;
> +
> +	if (root == NULL || root->node == NULL) {
> +		ext4_btree_trace("Empty tree\n");
> +		return;
> +	}
> +
> +	ext4_btree_trace("Btree Details:\n\n");
> +	ext4_btree_init_search_path(&spath);
> +	node = root->node;
> +	level = rootlevel = ext4_btree_get_level(node);
> +	pos = 0;
> +	while (level >= 0) {
> +		spath.node[level] = node;
> +		spath.pos[level] = pos;
> +		if (level > 0) {
> +			if (pos == 0)
> +				ext4_btree_index_node_print(&root->geo, node);
> +			numkeys = ext4_btree_get_numkeys(node);
> +			if (pos == numkeys) {
> +				if (level == rootlevel)
> +					break; /* reach the end
> +				/* go to parent node */
> +				level ++; 
> +				node = spath.node[level];
> +				pos = spath.pos[level] + 1;
> +			}
> +			else {
> +				/* go to next child node */
> +				level --;
> +				val = ext4_btree_val_addr(&root->geo, 
> +							  node, pos);
> +				node = fs_get_btree_node(val->blockno);
> +				pos = 0 ;
> +			}
> +		}
> +		else {
> +			ext4_btree_rec_node_print(&root->geo, node);
> +			if (level == rootlevel)
> +				break; /* reach the end
> +			/* go to parent node; */
> +			level ++; 
> +			node = spath.node[level];
> +			pos = spath.pos[level] + 1;
> +		}
> +	}
> +	ext4_btree_trace("\n");
> +}
> +
> +
> +/*
> + * Lookup for a record contain the specified key in btree
> + * Return NULL if the key is not found
> + */
> +struct ext4_btree_rec*
> +ext4_btree_search_key(struct ext4_btree_root *root, 
> +		      struct ext4_btree_key *key,
> +		      struct ext4_btree_search_path * spath)
> +{
> +	unsigned int i;
> +	int	level;
> +	struct ext4_btree_node *node;
> +	struct ext4_btree_key *tmp_key;
> +	struct ext4_btree_val *tmp_val;
> +	struct ext4_btree_geo *geo;
> +	struct ext4_btree_rec *rec = NULL;
> +
> +	if (root == NULL || root->node == NULL)
> +		return NULL;
> +	/* Search through the key-val index nodes. */
> +	node = root->node;
> +	geo = &root->geo;
> +	level = ext4_btree_get_level(node);
> +	while (level > 0) {
> +		for (i = 0; i < ext4_btree_get_numkeys(node)-1; i++) {
> +			tmp_key = ext4_btree_key_addr(geo, node, i + 1);
> +			if (ext4_btree_key_comp(geo, key, tmp_key) < 0) 
> +				break;
> +		}

If the keys and records are stored in sorted order, could you bsearch here
instead of linear scanning?  Granted the difference might be inconsequential
for the ~252 records in a 4K node, but for a 64k node that's a linear scan
of ~4092 records.

This goes for all the linear scans I see.

> +		ext4_btree_set_search_path(spath, level, node, i);
> +		tmp_val = ext4_btree_val_addr(geo, node, i);
> +		node = fs_get_btree_node(tmp_val->blockno);
> +		/* read failure*/
> +		if (node == NULL)
> +			return NULL;

I wonder if there ought to be a facility for returning integer error codes
and passing in a **node (as an out param) instead of using NULL to cover
"not found" and "badness happened".

> +		level --;
> +	} 
> +	/* Search the leaf node */
> +	assert(ext4_btree_get_level(node) == 0);
> +	rec = ext4_btree_rec_addr(geo, node, 0);
> +	i = 0;
> +	while (ext4_btree_rec_comp(geo, key, rec) > 0) {
> +		i++;
> +		if (i >= ext4_btree_get_numkeys(node)) {
> +			ext4_btree_set_search_path(spath, 0, node, i);
> +			return NULL;
> +		}
> +		rec = ext4_btree_rec_addr(geo, node, i);
> +	}
> +	ext4_btree_set_search_path(spath, 0, node, i);
> +	if (ext4_btree_rec_comp(geo, key, rec) == 0) 
> +		return rec; 
> +	else 
> +		return NULL;
> +}
> +
> +/*
> + * Lookup for a record contain the specified key in btree
> + * Return NULL if the key is not found
> + */
> +struct ext4_btree_rec*
> +ext4_btree_lookup(struct ext4_btree_root *root, struct ext4_btree_key *key)
> +{
> +	return ext4_btree_search_key(root, key, NULL);
> +}
> +
> +/*
> + * Insert a rec into a leaf node at specifid position
> + */
> +void  
> +ext4_btree_node_insert_in_leaf(struct ext4_btree_root *root,
> +			       struct ext4_btree_node *node,
> +		               struct ext4_btree_rec *rec, 
> +			       int pos)
> +{
> +	int numrecs;
> +	int i;
> +	struct ext4_btree_rec *tmprec;
> +	
> +	numrecs= ext4_btree_get_numrecs(node);
> +	for (i = numrecs; i > pos;i--) {
> +		tmprec = ext4_btree_rec_addr(&root->geo, node, i-1);
> +		ext4_btree_set_rec(&root->geo, node, i,tmprec);
> +	}

memmove?

> +	ext4_btree_set_rec(&root->geo, node, pos, rec);
> +	ext4_btree_update_numrecs(node,numrecs+1);
> +}
> +
> +/*
> + * Split a leaf node into two
> + */
> +struct ext4_btree_node *
> +ext4_btree_split_leaf(struct ext4_btree_root *root, 
> +		      struct ext4_btree_node *node)
> +{
> +	struct ext4_btree_node *rnode;
> +	struct ext4_btree_rec  *tmprec;
> +	unsigned int i;
> +
> +	rnode = ext4_btree_node_alloc();
> +	if (!rnode) {
> +		/* Cant allocate a new node, ERR*/
> +		return NULL;
> +	}
> +	for (i = EXT4_BTREE_MAX_RECS/2; i < EXT4_BTREE_MAX_RECS;i++) {
> +		tmprec = ext4_btree_rec_addr(&root->geo, node, i);
> +		ext4_btree_set_rec(&root->geo, rnode, 
> +			           (i-EXT4_BTREE_MAX_RECS/2), tmprec);
> +		ext4_btree_clear_rec(tmprec);

memcpy/memset?

> +	}
> +	ext4_btree_update_numrecs(rnode,EXT4_BTREE_MAX_RECS/2);
> +	ext4_btree_update_numrecs(node, EXT4_BTREE_MAX_RECS/2);
> +	return rnode;
> +}
> +
> +/*
> + * Split a index node into two
> + */
> +struct ext4_btree_node *
> +ext4_btree_split_index(struct ext4_btree_root *root, 
> +		       struct ext4_btree_node *node)
> +{
> +	struct ext4_btree_node *rnode;
> +	struct ext4_btree_key  *tmp_key;
> +	struct ext4_btree_val  *tmp_val;
> +	unsigned int i;
> +
> +	rnode = ext4_btree_node_alloc();
> +	if (!rnode) {
> +		/* Cant allocate a new node, ERR*/
> +		return NULL;
> +	}
> +	/* split key-val pairs between old node and new node */
> +	for (i = EXT4_BTREE_MAX_KEY_VAL_PAIRS/2; 
> +	     i < EXT4_BTREE_MAX_KEY_VAL_PAIRS; 
> +	     i++) {
> +		tmp_key = ext4_btree_key_addr(&root->geo, node, i);
> +		ext4_btree_set_key(&root->geo, rnode, 
> +				   (i-EXT4_BTREE_MAX_KEY_VAL_PAIRS/2),tmp_key);
> +		ext4_btree_clear_key(tmp_key);
> +		tmp_val = ext4_btree_val_addr(&root->geo, node, i);
> +		ext4_btree_set_val(&root->geo, rnode, 
> +				   (i-EXT4_BTREE_MAX_KEY_VAL_PAIRS/2),tmp_val);
> +		ext4_btree_clear_val(tmp_val);
> +	}
> +	/* set level and numkeys in new node */
> +	ext4_btree_update_level(rnode, ext4_btree_get_level(node));
> +	ext4_btree_update_numkeys(rnode,EXT4_BTREE_MAX_KEY_VAL_PAIRS/2);
> +	/* set numkeys in old node */
> +	ext4_btree_update_numkeys(node, EXT4_BTREE_MAX_KEY_VAL_PAIRS/2);
> +	return rnode;
> +}
> +
> +		       
> +/*
> + * Insert a key-val pair into a index node at specified position
> + */
> +void 
> +ext4_btree_node_insert_in_index(struct ext4_btree_root *root, 
> +     			       struct ext4_btree_node *node,
> +			       struct ext4_btree_key *key,
> +			       struct ext4_btree_val *val, 
> +			       int pos)	
> +{
> +	int i;
> +	int numkeys;
> +	struct ext4_btree_key *pkey;
> +	struct ext4_btree_val *pval;
> +
> +	numkeys = ext4_btree_get_numkeys(node);
> +	for (i = numkeys - 1; i >= pos; i--) {
> +		pkey = ext4_btree_key_addr(&root->geo, node, i);
> +		ext4_btree_set_key(&root->geo, node, i + 1, pkey);
> +		pval = ext4_btree_val_addr(&root->geo, node, i);
> +		ext4_btree_set_val(&root->geo, node, i + 1, pval);
> +	}
> +	ext4_btree_set_key(&root->geo, node, pos, key);
> +	ext4_btree_set_val(&root->geo, node, pos, val);
> +	ext4_btree_update_numkeys(node, numkeys + 1);
> +}
> +
> +/*
> + * Grow tree by one more level. Return the new root node.
> + */
> +struct ext4_btree_node *
> +ext4_btree_grow(struct ext4_btree_root *root,
> +		struct ext4_btree_node *lnode,
> +		struct ext4_btree_node *rnode,
> +		int level)
> +{
> +	struct ext4_btree_node * newroot;
> +	struct ext4_btree_key * key;
> +	struct ext4_btree_val val;
> +
> +	newroot = ext4_btree_node_alloc();
> +	if (!newroot) {
> +		/* Cant allocate a new node, ERR*/
> +		return NULL;
> +	}
> +
> +	ext4_btree_update_level(newroot, level);
> +
> +	key = ext4_btree_key_addr(&root->geo, lnode, 0);	
> +	ext4_btree_set_key(&root->geo, newroot, 0, key);
> +	val.blockno = ext4_btree_get_blockno(lnode);
> +	ext4_btree_set_val(&root->geo, newroot, 0, &val);
> +
> +	key = ext4_btree_key_addr(&root->geo, rnode, 0);	
> +	ext4_btree_set_key(&root->geo, newroot, 1, key);
> +	val.blockno = ext4_btree_get_blockno(rnode);
> +	ext4_btree_set_val(&root->geo, newroot, 1, &val); 
> +	
> +	ext4_btree_update_numkeys(newroot, 2);
> +
> +	return newroot;
> +
> +}
> +
> +/*
> + * Insert a record to the btree
> + */
> +int 
> +ext4_btree_insert(struct ext4_btree_root *root, struct ext4_btree_rec *rec)
> +{
> +	unsigned int level;
> +	struct ext4_btree_node *node, *rnode, *newroot;
> +	struct ext4_btree_key *key, *rkey;
> +	struct ext4_btree_val rval;
> +	struct ext4_btree_search_path spath;
> +	int pos, full, numkeys;
> +	struct ext4_btree_rec *searchrec;
> +
> +	if (root->node == NULL) {
> +		/* empty tree */
> +		node = ext4_btree_node_alloc();
> +		if (node == NULL)
> +			return -1;
> +		root->node = node;
> +		ext4_btree_update_level(root->node, 0);
> +		ext4_btree_trace(
> +			"==rec 0x%llx will be insert in node in block %lld "\
> +			"- level %d pos %d\n",
> +			rec->key.blockno,
> +			ext4_btree_get_blockno(root->node),
> +			ext4_btree_get_level(root->node),
> +			0);
> +
> +		ext4_btree_node_insert_in_leaf(root, root->node, rec, 0);
> +		return 0;
> +	}
> +
> +	/* 
> +	 * First we search if the key already present, 
> +	 * In the search process, all levels node pointer and position are stored 
> +	 * in search pointer for later use 
> +	 * there is no duplicated key allowed in the tree 
> +	 */
> +	ext4_btree_init_search_path(&spath);
> +	key = &rec->key;
> +	searchrec = ext4_btree_search_key(root, key, &spath);
> +
> +	if (searchrec) {
> +		node = spath.node[0];
> +		pos = spath.pos[0];
> +		ext4_btree_trace("==rec 0x%llx found in node in block %lld " \
> +				 "- level %d pos %d\n",
> +				rec->key.blockno,
> +				ext4_btree_get_blockno(node),
> +				ext4_btree_get_level(node), 
> +				pos);
> +		return -1;
> +	}
> +	level = 0;
> +	node = spath.node[0];
> +	pos = spath.pos[0];
> +	full =  ext4_btree_get_numkeys(node) == EXT4_BTREE_MAX_RECS;
> +	ext4_btree_trace(
> +		"==rec 0x%llx will be insert in node in block %lld "\
> +		"- level %d pos %d\n",
> +		rec->key.blockno,
> +		ext4_btree_get_blockno(node),
> +		ext4_btree_get_level(node),
> +		pos);
> +
> +	if (!full) {
> +		ext4_btree_node_insert_in_leaf(root, node, rec, pos); 
> +		while (pos == 0 && 
> +		       (++level <= ext4_btree_get_level(root->node))) {
> +			/* update parent key */
> +			node = spath.node[level];
> +			pos = spath.pos[level];
> +			ext4_btree_set_key(&root->geo, node, pos, key);
> +		}
> +		return 0;
> +	} 
> +
> +	/* check if B tree root is full and level reach the max */
> +	if ((ext4_btree_get_level(root->node) == EXT4_BTREE_MAX_LEVELS - 1) &&
> +	    (ext4_btree_get_numkeys(root->node) 
> +	    == EXT4_BTREE_MAX_KEY_VAL_PAIRS)) {
> +		ext4_btree_trace("Tree reach max level, no more insert\n");
> +		return -1; // Tree reach the max level
> +	}
> +
> +	/* leaf node is full, split it to make space to insert new rec*/
> +	numkeys = ext4_btree_get_numkeys(node);
> +	rnode = ext4_btree_split_leaf(root, node);
> +	if (rnode == NULL)
> +		return -1;
> +	if (pos > EXT4_BTREE_MAX_RECS/2)
> +		ext4_btree_node_insert_in_leaf(root, rnode, rec, 
> +			pos - EXT4_BTREE_MAX_RECS/2);
> +	else
> +		ext4_btree_node_insert_in_leaf(root, node, rec, pos);
> +	
> +	/* split index nodes if full, all the way up to root */
> +	while (level < ext4_btree_get_level(root->node)) {
> +		/* Pick up the first key*/
> +		rkey = ext4_btree_key_addr(&root->geo, rnode, 0);
> +		rval.blockno = ext4_btree_get_blockno(rnode);
> +		level ++;
> +		node = spath.node[level];
> +		pos = spath.pos[level];
> +		numkeys = ext4_btree_get_numkeys(node);
> +		full = (numkeys == EXT4_BTREE_MAX_KEY_VAL_PAIRS); 
> +		if (!full) {
> +			ext4_btree_node_insert_in_index(root, node, rkey, 
> +				&rval, pos + 1); 	
> +			break;
> +		} 
> +		rnode = ext4_btree_split_index(root, node);
> +		if (rnode == NULL)
> +			return -1;
> +		if (pos > EXT4_BTREE_MAX_KEY_VAL_PAIRS/2 ) {
> +			ext4_btree_node_insert_in_index(root, rnode, rkey, 
> +				&rval, pos - EXT4_BTREE_MAX_KEY_VAL_PAIRS/2 + 1);
> +		} else {
> +			ext4_btree_node_insert_in_index(root, node, rkey, 
> +				&rval, pos + 1);
> +		}
> +	}
> +	if (level == ext4_btree_get_level(node) && full) {
> +		/* If root is split, grow tree by one more level and assign new root */
> +		newroot = ext4_btree_grow(root, node, rnode, level + 1);
> +		if (newroot != NULL) {
> +			root->node = newroot; 
> +		}
> +	}
> +	return 0;
> +}
> +
> +
> +/*
> + * Delete one record from leaf node
> + */
> +void
> +ext4_btree_delete_one(struct ext4_btree_root *root,
> +		      struct ext4_btree_node *node,
> +		      int pos)
> +{
> +	unsigned int i;
> +	struct ext4_btree_rec* tmprec;
> +	unsigned int numrecs;
> +
> +	numrecs= ext4_btree_get_numrecs(node);
> +	for (i = pos; i< numrecs - 1; i++) {
> +		tmprec = ext4_btree_rec_addr(&root->geo, node, i + 1);
> +		ext4_btree_set_rec(&root->geo, node, i, tmprec);
> +	}
> +	ext4_btree_update_numrecs(node, numrecs - 1);
> +}
> +
> +/*
> + * Delete one key/val pair from index node
> + */
> +
> +void
> +ext4_btree_delete_one_keyval(struct ext4_btree_root *root,
> +			     struct ext4_btree_node *node,
> +			     int pos)
> +{
> +	unsigned int i;
> +	struct ext4_btree_key* key;
> +	struct ext4_btree_val* val;
> +	unsigned int numkeys;
> +
> +	numkeys= ext4_btree_get_numkeys(node);
> +	for (i = pos; i< numkeys - 1; i++) {
> +		key = ext4_btree_key_addr(&root->geo, node, i + 1);
> +		val = ext4_btree_val_addr(&root->geo, node, i + 1);
> +		ext4_btree_set_key(&root->geo, node, i, key);
> +		ext4_btree_set_val(&root->geo, node, i, val);
> +	}
> +	ext4_btree_update_numkeys(node, numkeys - 1);
> +
> +}
> +
> +
> +/*
> + * Borrow one record or key/val pair from left sibling 
> + */
> +void
> +ext4_btree_borrow_one_left (struct ext4_btree_root *root,
> +			    struct ext4_btree_node *parent,
> +			    struct ext4_btree_node *lnode,
> +			    struct ext4_btree_node *rnode,
> +			    int pos, 
> +			    int level)
> +{
> +	struct ext4_btree_rec *rec;
> +	struct ext4_btree_key *key;
> +	struct ext4_btree_val *val;
> +	int numrecs;
> +	int numkeys; 
> +
> +	if (level == 0) {
> +		numrecs = ext4_btree_get_numrecs(lnode);
> +		rec = ext4_btree_rec_addr(&root->geo, lnode, numrecs - 1);
> +		key = &rec->key;
> +		ext4_btree_node_insert_in_leaf(root, rnode, rec, 0);
> +		ext4_btree_delete_one(root, lnode, numrecs - 1);
> +	} else {
> +		numkeys = ext4_btree_get_numkeys(lnode);
> +		key = ext4_btree_key_addr(&root->geo, lnode, numkeys - 1);
> +		val = ext4_btree_val_addr(&root->geo, lnode, numkeys - 1);
> +		ext4_btree_node_insert_in_index(root, rnode, key, val, 0);
> +		ext4_btree_delete_one_keyval(root, lnode, numkeys - 1);
> +	}
> +	/* update parent node key */
> +	ext4_btree_set_key(&root->geo, parent, pos, key);
> +
> +}
> +
> +/* 
> + * Borrow one record or key/val pair from right sibling 
> + */
> +void
> +ext4_btree_borrow_one_right (struct ext4_btree_root *root,
> +			    struct ext4_btree_node *parent,
> +			    struct ext4_btree_node *lnode,
> +			    struct ext4_btree_node *rnode,
> +			    int pos, 
> +			    int level)
> +{
> +	struct ext4_btree_rec *rec;
> +	struct ext4_btree_key *key;
> +	struct ext4_btree_val *val;
> +	int numrecs;
> +	int numkeys;
> +
> +	if (level == 0) {
> +		rec = ext4_btree_rec_addr(&root->geo, rnode, 0);
> +		key = &rec->key;
> +		numrecs = ext4_btree_get_numrecs(lnode);
> +		ext4_btree_node_insert_in_leaf(root, lnode, rec, numrecs);
> +		ext4_btree_delete_one(root, rnode, 0);
> +	} else {
> +		key = ext4_btree_key_addr(&root->geo, rnode, 0);
> +		val = ext4_btree_val_addr(&root->geo, rnode, 0);
> +		numkeys = ext4_btree_get_numkeys(lnode);
> +		ext4_btree_node_insert_in_index(root, lnode, key, val, numkeys);
> +		ext4_btree_delete_one_keyval(root, rnode, 0);
> +	}
> +	/* update parent node key */
> +	ext4_btree_set_key(&root->geo, parent, pos + 1, key);
> +}
> +
> +int
> +ext4_btree_rotate(struct ext4_btree_root *root, 
> +		  struct ext4_btree_search_path *spath,
> +		  struct ext4_btree_node *node, int level)
> +{
> +	struct ext4_btree_val * val;
> +	struct ext4_btree_node *parent, *lnode, *rnode;
> +	int pos = 0;
> +	int numkeys;
> +
> +	parent = spath->node[level + 1];
> +	pos = spath->pos[level + 1];
> +
> +	if (pos > 0) {
> +		/* check the left sibling first*/
> +		val = ext4_btree_val_addr(&root->geo, parent, pos - 1);

node->node_header.leftsib?

> +		lnode = fs_get_btree_node(val->blockno);
> +		if (lnode) {
> +			numkeys = ext4_btree_get_numkeys(lnode); 
> +			if (numkeys >= EXT4_BTREE_MIN_RECS + 1) {
> +				/* we could shift a record from left sibling to the node*/
> +				ext4_btree_borrow_one_left(root, parent, lnode,
> +						           node, pos, level);
> +				return 0;
> +			}
> +		}
> +	}
> +
> +	numkeys = ext4_btree_get_numkeys(parent);
> +	if (pos < numkeys -1) {
> +		val = ext4_btree_val_addr(&root->geo, parent, pos + 1);
> +		rnode = fs_get_btree_node(val->blockno);
> +		if (rnode) {
> +			numkeys = ext4_btree_get_numkeys(rnode);
> +			if (numkeys >= EXT4_BTREE_MIN_RECS + 1) {
> +				/* we could shift a record from left sibling to the node*/
> +				ext4_btree_borrow_one_right(root, parent, node, 
> +						            rnode, pos, level);
> +				return 0;
> +			}
> +		}
> +	}
> +
> +	return -1;
> +
> +}
> +
> +/*
> + * Merge leaf nodes
> + */
> +
> +int
> +ext4_btree_merge_leaf(struct ext4_btree_root *root, 
> +		 struct ext4_btree_search_path *spath,
> +		 struct ext4_btree_node *node)
> +{
> +	int num, lnum, rnum; 
> +	struct ext4_btree_node * parent, *lnode, *rnode;
> +	int i, pos;
> +	struct ext4_btree_rec *rec;
> +	struct ext4_btree_val *val;
> +
> +	parent = spath->node[1];
> +	pos = spath->pos[1];
> +	
> +	num = ext4_btree_get_numrecs(node);
> +
> +	/* try to merge left sibling first */
> +	if (pos > 0) {
> +		val = ext4_btree_val_addr(&root->geo, parent, pos - 1); 
> +		lnode = fs_get_btree_node(val->blockno);
> +		if (!lnode) {
> +			return -1;
> +			/* err!*/
> +		}
> +
> +		lnum = ext4_btree_get_numrecs(lnode);
> +
> +		for (i = 0; i < num; i++) {
> +			rec = ext4_btree_rec_addr(&root->geo, node, i);
> +			ext4_btree_node_insert_in_leaf(root, lnode, rec, lnum+i);
> +		}
> +		// delete parent key-val pair
> +		ext4_btree_delete_one_keyval(root, parent, pos);
> +		ext4_btree_node_free(node);
> +		return 0;
> +	}
> +	/* then try to merge with right sibling */
> +	val = ext4_btree_val_addr(&root->geo, parent, pos + 1); 
> +	rnode = fs_get_btree_node(val->blockno);
> +	if (!rnode) {
> +		return -1;
> +		/* err!*/
> +	}
> +	
> +	rnum = ext4_btree_get_numrecs(rnode);
> +	
> +	for (i = 0; i < rnum; i++) {
> +		rec = ext4_btree_rec_addr(&root->geo, rnode, i);
> +		ext4_btree_node_insert_in_leaf(root, node, rec, num+i);
> +	}
> +	// delete parent key-val pair
> +	ext4_btree_delete_one_keyval(root, parent, pos + 1);
> +	ext4_btree_node_free(rnode);
> +	return 0;
> +}
> +
> +
> +/*
> + * Merge index nodes
> + */
> +
> +int
> +ext4_btree_merge_index(struct ext4_btree_root *root, 
> +		 struct ext4_btree_search_path *spath,
> +		 struct ext4_btree_node *node, int level)
> +
> +{
> +	int num, lnum, rnum, pnum; 
> +	struct ext4_btree_node * parent, *lnode, *rnode;
> +	int i, pos;
> +	struct ext4_btree_key *key;
> +	struct ext4_btree_val *val;
> +
> +	parent = spath->node[level + 1];
> +	pos = spath->pos[level + 1];
> +	
> +	num = ext4_btree_get_numkeys(node);
> +
> +	/* try to merge left sibling first */
> +	if (pos > 0) {
> +		val = ext4_btree_val_addr(&root->geo, parent, pos - 1); 
> +		lnode = fs_get_btree_node(val->blockno);
> +		if (!lnode) {
> +			/* err!*/
> +			return -1;
> +		}
> +
> +		lnum = ext4_btree_get_numkeys(lnode);
> +
> +		for (i = 0; i < num; i++) {
> +			key = ext4_btree_key_addr(&root->geo, node, i);
> +			val = ext4_btree_val_addr(&root->geo, node, i);
> +			ext4_btree_node_insert_in_index(root, lnode, key, 
> +							val, lnum + i);
> +		}
> +		// delete parent key-val pair
> +		ext4_btree_delete_one_keyval(root, parent, pos);
> +		ext4_btree_node_free(node);
> +		return 0;
> +	}
> +	pnum = ext4_btree_get_numkeys(parent);
> +	if (pnum > 1) {
> +		/* then try to merge with right sibling */
> +		val = ext4_btree_val_addr(&root->geo, parent, 1);  /* pos is always 0*/
> +		rnode = fs_get_btree_node(val->blockno);
> +		if (!rnode) {
> +			return -1;
> +			/* err!*/
> +		}
> +		
> +		rnum = ext4_btree_get_numkeys(rnode);
> +		
> +		for (i = 0; i < rnum; i++) {
> +			key = ext4_btree_key_addr(&root->geo, rnode, i);
> +			val = ext4_btree_val_addr(&root->geo, rnode, i);
> +			ext4_btree_node_insert_in_index(root, node, key, 
> +							val, num + i);
> +		}
> +		// delete parent key-val pair
> +		ext4_btree_delete_one_keyval(root, parent, pos + 1);
> +		ext4_btree_node_free(rnode);
> +		ext4_btree_print(root);
> +	} else{
> +		/* shrink level */
> +		ext4_btree_node_free(root->node);
> +		root->node = node;
> +		ext4_btree_print(root);
> +	}
> +
> +	return 0;
> +}
> +
> +
> +/*
> + * Delete a record from the btree
> + */
> +int 
> +ext4_btree_delete(struct ext4_btree_root *root, struct ext4_btree_key *key)
> +{
> +	struct ext4_btree_node *node, *parent;
> +	struct ext4_btree_search_path spath;
> +	int pos, p_pos;
> +	struct ext4_btree_rec *searchrec;
> +	int level;
> +	int tree_height = ext4_btree_get_level(root->node);
> +	int ret;
> +
> +	/* 
> +	 * First we search if the key already present, 
> +	 * In the search process, all levels node pointer and position are stored 
> +	 * in search pointer for later use 
> +	 * there is no duplicated key allowed in the tree 
> +	 */
> +	ext4_btree_init_search_path(&spath);
> +	searchrec = ext4_btree_search_key(root, key, &spath);
> +	if (!searchrec) 
> +		/* record doesnt exist */
> +		return -1;
> +	node = spath.node[0];
> +	pos = spath.pos[0];
> +	ext4_btree_trace("==Delete : rec 0x%llx found in node in block %lld " \
> +			 "- level %d pos %d\n",
> +			key->blockno,
> +			ext4_btree_get_blockno(node),
> +			ext4_btree_get_level(node), 
> +			pos);
> +	ext4_btree_delete_one(root, node, pos);
> +	if (pos == 0) {
> +		/* update parent key */
> +		parent = spath.node[1];
> +		p_pos = spath.pos[1];
> +		key = ext4_btree_key_addr(&root->geo, node, 0);
> +		ext4_btree_set_key(&root->geo, parent, p_pos, key);
> +	}
> +	/*
> +	 * If the node is root node, which we do not require minmum number of records,
> +	 * then we are good now, exit 
> +	 */
> +	if (ext4_btree_get_level(root->node) == 0)
> +		return 0;
> +	if (ext4_btree_get_numrecs(node) >= EXT4_BTREE_MIN_RECS) 
> +		return 0;
> +
> +	level = 0;
> +	while (level < tree_height && 
> +	       ext4_btree_get_numrecs(node) < EXT4_BTREE_MIN_RECS) {
> +		ret = ext4_btree_rotate(root, &spath, node, level);
> +		if (!ret)
> +			return 0; /* node can be rotated with sibling nodes */
> +
> +		if (level == 0) 
> +			ret = ext4_btree_merge_leaf(root, &spath, node);
> +		else
> +
> +			ret = ext4_btree_merge_index(root, &spath, 
> +				                     node, level);
> +		if (ret) {
> +			/* err*/
> +			return ret;
> +		}
> +		level ++;
> +		node = spath.node[level];
> +	}
> +	return 0;
> +}
> +
> +
> +/* 
> + * Check if a btree is valid 
> + */
> +
> +int 
> +ext4_btree_index_node_check(struct ext4_btree_root * root, 
> +			    struct ext4_btree_node *node)
> +{
> +	int i;
> +	int num_keys;
> +	struct ext4_btree_key *key, *lkey = NULL;
> +	struct ext4_btree_val *val;
> +
> +	if (node == NULL)
> +		return -1;
> +
> +	num_keys =  ext4_btree_get_numkeys(node);
> +	if (root->node != node) {
> +		// non-root node
> +		if (num_keys < EXT4_BTREE_MIN_KEY_VAL_PAIRS || 
> +		    num_keys > EXT4_BTREE_MAX_KEY_VAL_PAIRS) {

I think it's important to check !(num_keys > EXT4_BTREE_MAX_KEY_VAL_PAIRS)
for root nodes?

Also, there's no check of CRC, leftsib, rightsib, or blockno.

> +			ext4_btree_trace("Invalid numkeys %d in node %lld -  " \
> +				"level %d\n",
> +				num_keys,
> +				ext4_btree_get_blockno(node),
> +				ext4_btree_get_level(node));
> +			return -2;
> +		}
> +	}
> +
> +	for (i = 0; i < num_keys; i++)	{
> +		key = ext4_btree_key_addr(&root->geo, node, i);
> +		val = ext4_btree_val_addr(&root->geo, node, i);
> +		if (lkey != NULL && ext4_btree_key_comp(&root->geo, lkey, key) >= 0) {
> +			ext4_btree_trace("Keys are not sorted in node %lld" \
> +				"- level %d lkey %d 0x%llx key %d 0x%llx\n",
> +				ext4_btree_get_blockno(node),
> +				ext4_btree_get_level(node), 
> +				i-1, key->blockno, i, key->blockno);
> +			return -3;
> +		}
> +		lkey = key;
> +	}
> +	return 0;
> +}
> +
> +			     
> +int 
> +ext4_btree_rec_node_check(struct ext4_btree_root * root, 
> +   		          struct ext4_btree_node *node)
> +{
> +	int i;
> +	struct ext4_btree_rec *rec, *lrec = NULL;
> +	int num_recs; 
> +	
> +	if (node == NULL)
> +		return -1;
> +	
> +	num_recs =  ext4_btree_get_numrecs(node);
> +	if (root->node != node) {
> +		// non-root node
> +		if (num_recs < EXT4_BTREE_MIN_RECS || 
> +		    num_recs > EXT4_BTREE_MAX_RECS) {

I think it's still necessary to check !(num_recs > EXT4_BTREE_MAX_RECS) for
root nodes.

Also, there's no check of CRC, leftsib, rightsib, or blockno.

> +			ext4_btree_trace("Invalid numrecs %d in node %lld -  " \
> +				"level %d\n",
> +				num_recs,
> +				ext4_btree_get_blockno(node),
> +				ext4_btree_get_level(node));
> +			return -2;

Wading in a bit here, but ... return -EUCLEAN?

More generally, are these int returns supposed to be regular error codes?

> +		}
> +	}
> +	for (i = 0; i < num_recs; i++) {
> +		rec = ext4_btree_rec_addr(&root->geo, node, i);
> +		if (lrec != NULL && 
> +		    ext4_btree_key_comp(&root->geo, &lrec->key, &rec->key) >= 0) {
> +			ext4_btree_trace("Rec are not sorted in block 0x%llx" \
> +				"lkey %d 0x%llx key %d 0x%llx \n", 
> +				ext4_btree_get_blockno(node), 
> +				i - 1, lrec->key.blockno, i, rec->key.blockno);
> +			return -3;
> +		}
> +	}
> +	return 0;
> +}
> +
> +int 
> +ext4_btree_valid_check(struct ext4_btree_root *root)
> +{
> +	struct ext4_btree_search_path spath;

96 bytes on the stack, hm.  I guess it's not likely to nest too many levels
deep.

> +	struct ext4_btree_header * header;
> +	struct ext4_btree_node * node;
> +	struct ext4_btree_val * val;
> +	int level;
> +	int rootlevel;
> +	int pos;
> +	int numkeys;
> +	int result;
> +	
> +	if (root == NULL || root->node == NULL) {
> +		return 0;
> +	}
> +	/* check geo */
> +	if (root->geo.header_len == 0 ||
> +	    root->geo.node_len == 0 ||
> +	    root->geo.key_len == 0 ||
> +	    root->geo.val_len == 0 ||
> +	    root->geo.rec_len == 0 ||
> +	    root->geo.max_pairs == 0 ||
> +	    root->geo.max_records == 0)
> +	{
> +		ext4_btree_trace("tree geo is invalid %d %d %d %d %d %d %d\n",
> +			root->geo.header_len,
> +			root->geo.node_len,
> +			root->geo.key_len, 
> +			root->geo.val_len, 
> +			root->geo.rec_len,
> +			root->geo.max_pairs, 
> +			root->geo.max_records);
> +		return -1;
> +	}
> +	if (root->geo.max_pairs % 2 == 1 || root->geo.max_records % 2 == 1) {
> +		ext4_btree_trace("tree geo does not support odd pairs %d %d\n",

Oh?  I'm a little surprised by this requirement, since the header didn't say
anything about it.

(Also, seeing as those two values are known at compile time, this could be
a compiletime_assert()?)

> +			root->geo.max_pairs, 
> +			root->geo.max_records);
> +		return -1;
> +	}
> +	    
> +	/* check tree */
> +	ext4_btree_init_search_path(&spath);
> +	node = root->node;
> +	level = rootlevel = ext4_btree_get_level(node);
> +	pos = 0;

Should we check level < 8 here?

> +	while (level >= 0) {
> +		spath.node[level] = node;
> +		spath.pos[level] = pos;
> +		header = ext4_btree_header_addr(node);
> +		if (header->btree_magic != REF_BTREE_MAGIC) {
> +			ext4_btree_trace("node 0x%p block %lld has no MAGIC stamp. level %d pos %d\n", 
> +					 node, ext4_btree_get_blockno(node), level, pos);
> +			return -1;
> +		}

I think there needs to be a check for header->level and header->numkeys here.

(Ok, enough for now.)

--D

> +		if (level > 0) {
> +			if (pos == 0) {
> +				result = ext4_btree_index_node_check(root, 
> +								     node);
> +				if (result != 0)
> +					return result;
> +			}
> +			numkeys = ext4_btree_get_numkeys(node);
> +			if (pos == numkeys) {
> +				if (level == rootlevel)
> +					break; /* reach the end
> +				/* go to parent node */
> +				level ++; 
> +				node = spath.node[level];
> +				pos = spath.pos[level] + 1;
> +			}
> +			else {
> +				/* go to next child node */
> +				level --;
> +				val = ext4_btree_val_addr(&root->geo, 
> +							  node, pos);
> +				node = fs_get_btree_node(val->blockno);
> +				pos = 0;
> +			}
> +		}
> +		else {
> +			result = ext4_btree_rec_node_check(root, node);
> +			if (result != 0)
> +				return result;
> +			if (level == rootlevel)
> +				break; // reach the end
> +			/* go to parent node; */
> +			level ++; 
> +			node = spath.node[level];
> +			pos = spath.pos[level] + 1;
> +		}
> +	}
> +	return 0;
> +}
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
