From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 02/10 v1][RESEND] ext4: add operations on extent
 status tree
Date: Tue, 31 Jul 2012 21:18:10 +0800
Message-ID: <20120731131810.GA31501@gmail.com>
References: <1342943986-12413-1-git-send-email-wenqing.lz@taobao.com>
 <1342943986-12413-3-git-send-email-wenqing.lz@taobao.com>
 <alpine.LFD.2.00.1207301343060.26051@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	wenqing.lz@taobao.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1207301343060.26051@localhost>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Lukas,

Thanks for a comprehensive review. :-)

On Tue, Jul 31, 2012 at 01:55:14PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
[cut...]
> > +static inline ext4_lblk_t extent_status_end(struct extent_status *=
es)
> > +{
> > +	if (es->start + es->len < es->start)
> > +		return (ext4_lblk_t)-1;
>=20
> Is this possible to happen ? It seems to me that if so, it means
> that the extent is corrupted and we should do something about this
> rather than ignore the problem by returning -1 (callers does not
> actually check for it), at least warning should be in place.

Yes, ext4_warning() will be added to tell user that we meet a problem.

>=20
> > +	return es->start + es->len;
>=20
> This seems like it should rather be es->start + es->len - 1, since
> the function name suggests that we should get the last block of the
> extent. Having it this way seems error prone to the off by one
> errors.

Will fix it.

>=20
> > +}
> > +
> > +/*
> > + * search through the tree for an delayed_extent with a given offs=
et.  If
> > + * it can't be found, try to find next extent.
>=20
> This helper could be used by any other extent tree in the ext4 not
> just for delayed extents right (if we're going to add some in the
> future)? So we should change the comment, because it is generic
> enough.

Until now it seems that this function only is used by io tree itself.
As Ted described before, there is an implementation of big extent tree
in Google, and this function might be used by it.  But firstly we will
implement these two features separately.  Certainly I will change the
comment if necessary.

>=20
> > + */
> > +static struct extent_status *__es_tree_search(struct rb_root *root=
,
> > +						ext4_lblk_t offset)
> > +{
> > +	struct rb_node *node =3D root->rb_node;
> > +	struct extent_status *es =3D NULL;
> > +
> > +	while (node) {
> > +		es =3D rb_entry(node, struct extent_status, rb_node);
> > +		if (offset < es->start)
> > +			node =3D node->rb_left;
> > +		else if (offset >=3D extent_status_end(es))
> > +			node =3D node->rb_right;
> > +		else
> > +			return es;
> > +	}
> > +
> > +	if (es && offset < es->start)
> > +		return es;
> > +
> > +	if (es && offset >=3D extent_status_end(es)) {
> > +		node =3D rb_next(&es->rb_node);
> > +		return node ? rb_entry(node, struct extent_status, rb_node) :
> > +			      NULL;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +/*
> > + * ext4_es_find_extent: find the 1st delayed extent covering @es->=
start
> > + * if it exists, otherwise, the next extent after @es->start.
> > + *
> > + * @inode: the inode which owns delayed extents
> > + * @es: delayed extent that we found
> > + *
> > + * Returns next block beyond the found extent.
>=20
> This is not exactly right isn't it ? From what I can see it returns
> the first block of the next extent after the one we're returning in
> es, or EXT_MAX_BLOCKS if no extent is found.

Will fix it.

>=20
> > + * Delayed extent is returned via @es.
> > + */
> > +ext4_lblk_t ext4_es_find_extent(struct inode *inode, struct extent=
_status *es)
> > +{
> > +	struct ext4_es_tree *tree;
> > +	struct extent_status *es1;
> > +	struct rb_node *node;
> > +	ext4_lblk_t ret =3D EXT_MAX_BLOCKS;
>=20
> Would not it make sense to try the cache first ? Maybe we do not
> need to search the tree at all ?

Yes, you are right.  I will add this stuff in next version.

>=20
> > +
> > +	es->len =3D 0;
> > +	tree =3D &EXT4_I(inode)->i_es_tree;
> > +	es1 =3D __es_tree_search(&tree->root, es->start);
> > +	if (es1) {
> > +		tree->cache_es =3D es1;
> > +		es->start =3D es1->start;
> > +		es->len =3D es1->len;
> > +		node =3D rb_next(&es1->rb_node);
> > +		if (node) {
> > +			es1 =3D rb_entry(node, struct extent_status, rb_node);
> > +			ret =3D es1->start;
> > +		}
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static struct extent_status *
> > +ext4_es_alloc_extent(ext4_lblk_t start, ext4_lblk_t len)
> > +{
> > +	struct extent_status *es;
> > +	es =3D kmem_cache_alloc(ext4_es_cachep, GFP_NOFS);
> > +	if (es =3D=3D NULL)
> > +		return NULL;
> > +	es->start =3D start;
> > +	es->len =3D len;
> > +	return es;
> > +}
> > +
> > +static void ext4_es_free_extent(struct extent_status *es)
> > +{
> > +	kmem_cache_free(ext4_es_cachep, es);
> > +}
> > +
> > +static void ext4_es_try_to_merge_left(struct ext4_es_tree *tree,
> > +				      struct extent_status *es)
> > +{
> > +	struct extent_status *es1;
> > +	struct rb_node *node;
> > +
> > +	node =3D rb_prev(&es->rb_node);
> > +	if (!node)
> > +		return;
> > +
> > +	es1 =3D rb_entry(node, struct extent_status, rb_node);
> > +	if (extent_status_end(es1) =3D=3D es->start) {
> > +		es1->len +=3D es->len;
> > +		rb_erase(&es->rb_node, &tree->root);
> > +		if (es =3D=3D tree->cache_es)
> > +			tree->cache_es =3D es1;
> > +		ext4_es_free_extent(es);
> > +	}
> > +}
> > +
> > +static void ext4_es_try_to_merge_right(struct ext4_es_tree *tree,
> > +				       struct extent_status *es)
> > +{
> > +	struct extent_status *es1;
> > +	struct rb_node *node;
> > +
> > +	node =3D rb_next(&es->rb_node);
> > +	if (!node)
> > +		return;
> > +
> > +	es1 =3D rb_entry(node, struct extent_status, rb_node);
> > +	if (es1->start =3D=3D extent_status_end(es)) {
> > +		es->len +=3D es1->len;
> > +		rb_erase(node, &tree->root);
> > +		if (es1 =3D=3D tree->cache_es)
> > +			tree->cache_es =3D es;
> > +		ext4_es_free_extent(es1);
> > +	}
> > +}
> > +
> > +/*
> > + * ext4_es_add_space: adds a space to a delayed extent tree.
> > + * Caller holds inode->i_data_sem.
> > + *
> > + * ext4_es_add_space is callyed by ext4_dealyed_write_begin and
> > + * ext4_es_remove_space.
> > + *
> > + * Return 0 on success, error code on failure.
> > + */
> > +int ext4_es_add_space(struct inode *inode, ext4_lblk_t offset, ext=
4_lblk_t len)
>=20
> I would rather call the function ext4_es_add_extent(), but that may
> be subjective.

IMHO ext4_es_insert_extent() might be a better name because it can be
consistent with ext4_ext_insert_extent().

>=20
> > +{
> > +	struct ext4_es_tree *tree =3D &EXT4_I(inode)->i_es_tree;
> > +	struct rb_node **p =3D &tree->root.rb_node;
> > +	struct rb_node *parent =3D NULL;
> > +	struct extent_status *es;
> > +	ext4_lblk_t end =3D offset + len;
> > +
> > +	BUG_ON(end <=3D offset);
> > +
> > +	es =3D tree->cache_es;
> > +	es_debug("add [%u/%u) to extent status tree of inode %lu\n",
> > +		 offset, len, inode->i_ino);
> > +
> > +	if (es && extent_status_end(es) =3D=3D offset) {
> > +		es_debug("cached by [%u/%u)\n", es->start, es->len);
> > +		es->len +=3D len;
> > +		ext4_es_try_to_merge_right(tree, es);
> > +		goto out;
> > +	} else if (es && es->start =3D=3D end) {
> > +		es_debug("cached by [%u/%u)\n", es->start, es->len);
> > +		es->start =3D offset;
> > +		es->len +=3D len;
> > +		ext4_es_try_to_merge_left(tree, es);
> > +		goto out;
> > +	} else if (es && es->start <=3D offset &&
> > +		   extent_status_end(es) >=3D end) {
> > +		es_debug("cached by [%u/%u)\n", es->start, es->len);
> > +		goto out;
> > +	}
> > +
> > +	while (*p) {
> > +		parent =3D *p;
> > +		es =3D rb_entry(parent, struct extent_status, rb_node);
> > +
> > +		if (offset < es->start) {
> > +			if (end =3D=3D es->start) {
> > +				es->len +=3D len;
> > +				es->start =3D offset;
> > +				goto out;
> > +			}
> > +			p =3D &(*p)->rb_left;
> > +		} else if (offset >=3D extent_status_end(es)) {
> > +			if (extent_status_end(es) =3D=3D offset) {
> > +				es->len +=3D len;
> > +				goto out;
> > +			}
> > +			p =3D &(*p)->rb_right;
> > +		} else
> > +			goto out;
> > +	}
> > +
> > +	es =3D ext4_es_alloc_extent(offset, len);
> > +	if (!es)
> > +		return -ENOMEM;
> > +	rb_link_node(&es->rb_node, parent, p);
> > +	rb_insert_color(&es->rb_node, &tree->root);
> > +
> > +out:
> > +	tree->cache_es =3D es;
> > +	ext4_es_print_tree(inode);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * ext4_es_remove_space() removes a space from a delayed extent tr=
ee.
> > + * Caller holds inode->i_data_sem.
> > + *
> > + * Return 0 on success, error code on failure.
> > + */
> > +int ext4_es_remove_space(struct inode *inode, ext4_lblk_t offset,
> > +			 ext4_lblk_t len)
>=20
> Again, my subjective opinion is that it could be rather called
> ext4_es_remove_extent().

Will fix it.

>=20
> > +{
> > +	struct rb_node *node;
> > +	struct ext4_es_tree *tree;
> > +	struct extent_status *es;
> > +	struct extent_status orig_es;
> > +	ext4_lblk_t len1, len2, end;
> > +
> > +	es_debug("remove [%u/%u) from extent status tree of inode %lu\n",
> > +		 offset, len, inode->i_ino);
>=20
> Since you're adding tracepoints later on, are those debug messages
> necessary ?

Agree, I will remove this debug message.

>=20
> > +
> > +	end =3D offset + len;
> > +	BUG_ON(end <=3D offset);
> > +	tree =3D &EXT4_I(inode)->i_es_tree;
> > +	es =3D __es_tree_search(&tree->root, offset);
> > +	if (!es)
> > +		goto out;
> > +
> > +	/* Simply invalidate cache_es. */
> > +	tree->cache_es =3D NULL;
> > +
> > +	orig_es.start =3D es->start;
> > +	orig_es.len =3D es->len;
> > +	len1 =3D offset > es->start ? offset - es->start : 0;
> > +	len2 =3D extent_status_end(es) > end ?
> > +	       extent_status_end(es) - end : 0;
> > +	if (len1 > 0)
> > +		es->len =3D len1;
> > +	if (len2 > 0) {
> > +		if (len1 > 0) {
> > +			int err;
> > +			err =3D ext4_es_add_space(inode, end, len2);
> > +			if (err) {
> > +				es->start =3D orig_es.start;
> > +				es->len =3D orig_es.len;
> > +				return err;
> > +			}
> > +		} else {
> > +			es->start =3D end;
> > +			es->len =3D len2;
> > +		}
> > +		goto out;
> > +	}
> > +
> > +	if (len1 > 0) {
> > +		node =3D rb_next(&es->rb_node);
> > +		if (!node)
> > +			es =3D rb_entry(node, struct extent_status, rb_node);
> > +		else
> > +			es =3D NULL;
> > +	}
> > +
> > +	while (es && extent_status_end(es) <=3D end) {
> > +		node =3D rb_next(&es->rb_node);
> > +		rb_erase(&es->rb_node, &tree->root);
> > +		ext4_es_free_extent(es);
> > +		if (!node) {
> > +			es =3D NULL;
> > +			break;
> > +		}
> > +		es =3D rb_entry(node, struct extent_status, rb_node);
> > +	}
> > +
> > +	if (es && es->start < end) {
> > +		len1 =3D extent_status_end(es) - end;
> > +		es->start =3D end;
> > +		es->len =3D len1;
> > +	}
> > +
> > +out:
> > +	ext4_es_print_tree(inode);
> > +	return 0;
> > +}
> > diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> > index d87fd71..8fe8084 100644
> > --- a/fs/ext4/extents_status.h
> > +++ b/fs/ext4/extents_status.h
> > @@ -8,6 +8,12 @@
> >  #ifndef _EXT4_EXTENTS_STATUS_H
> >  #define _EXT4_EXTENTS_STATUS_H
> > =20
> > +#ifdef ES_DEBUG
> > +#define es_debug(a...)         printk(a)
>=20
> Please take a look at the ext4_debug() or ext_debug(), maybe you can
> use it, or at least reuse the code from it.

Yes, I will reuse the code from ext4_debug() as much as possible.

Regards,
Zheng

>=20
> > +#else
> > +#define es_debug(a...)
> > +#endif
> > +
> >  struct extent_status {
> >  	struct rb_node rb_node;
> >  	ext4_lblk_t start;	/* first block extent covers */
> > @@ -19,4 +25,15 @@ struct ext4_es_tree {
> >  	struct extent_status *cache_es;	/* recently accessed extent */
> >  };
> > =20
> > +extern int __init ext4_init_es(void);
> > +extern void ext4_exit_es(void);
> > +extern void ext4_es_init_tree(struct ext4_es_tree *tree);
> > +
> > +extern int ext4_es_add_space(struct inode *inode, ext4_lblk_t star=
t,
> > +				ext4_lblk_t len);
> > +extern int ext4_es_remove_space(struct inode *inode, ext4_lblk_t s=
tart,
> > +				ext4_lblk_t len);
> > +extern ext4_lblk_t ext4_es_find_extent(struct inode *inode,
> > +				struct extent_status *es);
> > +
> >  #endif /* _EXT4_EXTENTS_STATUS_H */
> >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
