From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/6] mm: Invalidate DAX radix tree entries only if
 appropriate
Date: Fri, 9 Dec 2016 13:02:33 +0100
Message-ID: <20161209120233.GA9876@quack2.suse.cz>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
 <1479980796-26161-3-git-send-email-jack@suse.cz>
 <20161129193403.GA12396@cmpxchg.org>
 <20161130080841.GD16667@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	linux-nvdimm@lists.01.org
To: Johannes Weiner <hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20161130080841.GD16667@quack2.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Wed 30-11-16 09:08:41, Jan Kara wrote:
> > > +static int __dax_invalidate_mapping_entry(struct address_space *mapping,
> > > +					  pgoff_t index, bool trunc)
> > > +{
> > > +	int ret = 0;
> > > +	void *entry;
> > > +	struct radix_tree_root *page_tree = &mapping->page_tree;
> > > +
> > > +	spin_lock_irq(&mapping->tree_lock);
> > > +	entry = get_unlocked_mapping_entry(mapping, index, NULL);
> > > +	if (!entry || !radix_tree_exceptional_entry(entry))
> > > +		goto out;
> > > +	if (!trunc &&
> > > +	    (radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_DIRTY) ||
> > > +	     radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE)))
> > > +		goto out;
> > > +	radix_tree_delete(page_tree, index);
> > 
> > You could use the new __radix_tree_replace() here and save a second
> > tree lookup.
> 
> Hum, I'd need to return 'node' from get_unlocked_mapping_entry(). So
> probably I'll do it in a patch separate from this fix. But thanks for
> suggestion.

So I did this and quickly spotted a problem that when you use
__radix_tree_replace() to clear an entry, it will leave tags for that entry
set and that results in surprises. So I think I'll leave the code with
radix_tree_delete() for now.

It would probably make sense to make __radix_tree_replace() to clear tags
when we replace entry with NULL or at least WARN if some tags are set...
What do you think?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
