From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Thu, 6 Apr 2017 13:05:43 -0700
Message-ID: <20170406200543.GE31725@bombadil.infradead.org>
References: <1491250577.2673.20.camel@redhat.com>
 <87h924kh6t.fsf@notabene.neil.brown.name>
 <20170404115358.GH30811@bombadil.infradead.org>
 <1491308268.20445.4.camel@redhat.com>
 <20170404161247.GJ30811@bombadil.infradead.org>
 <1491323146.309.1.camel@redhat.com>
 <20170404170909.GK30811@bombadil.infradead.org>
 <1491421792.18658.20.camel@redhat.com>
 <87efx6tnbr.fsf@notabene.neil.brown.name>
 <1491506092.9621.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491506092.9621.2.camel@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 06, 2017 at 03:14:52PM -0400, Jeff Layton wrote:
> @@ -868,6 +869,7 @@ struct file {
>  	struct list_head	f_tfile_llink;
>  #endif /* #ifdef CONFIG_EPOLL */
>  	struct address_space	*f_mapping;
> +	u32			f_wb_err;
>  } __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
>  

I think we can squeeze that in next to f_flags?

> +/**
> + * filemap_set_wb_error - set the wb error in the mapping for later reporting
> + * @mapping: mapping in which the error should be set
> + * @err: error to set. must be negative value but not less than -MAX_ERRNO

Do we want to have users call filemap_set_wb_error(mapping, EIO)
or filemap_set_wb_error(mapping, -EIO)?  Either way, we can assert
that it's in the correct range (oh look, we have at least one user of
mapping_set_error calling it with a positive errno ...)

I've been playing with positive or negative errnos for the xarray, and
positive looks better to me, although there's a definite advantage to
being able to just call filemap_set_wb_error(mapping, result).

#define XAS_ERROR(errno)        ((struct xa_node *)((errno << 1) | 1))

static inline int xas_error(const struct xa_state *xas)
{
        unsigned long v = (unsigned long)xas->xa_node;
        return (v & 1) ? -(v >> 1) : 0;
}

static inline void xas_set_err(struct xa_state *xas, unsigned long err)
{
        XA_BUG_ON(err > MAX_ERRNO);
        xas->xa_node = XAS_ERROR(err);
}

> +	/*
> +	 * Ensure the error code actually fits where we want it to go. If it
> +	 * doesn't then just throw a warning and don't record anything.
> +	 */
> +	if (unlikely(err > 0 || err < -MAX_ERRNO)) {
> +		WARN(1, "err=%d\n", err);
> +		return;
> +	}

Cute trick to make this more succinct:

	if (WARN(err > 0 || err < -MAX_ERRNO), "err = %d\n", err)
		return;
or even ...

	if (WARN((unsigned int)-err > MAX_ERRNO), "err = %d\n", err)
		return;

> +		/* Clear out error bits and set new error */
> +		new = (old & ~MAX_ERRNO) | -err;
> +
> +		/* Only increment if someone has looked at it */
> +		if (old & WB_ERR_SEEN) {
> +			new += WB_ERR_CTR_INC;
> +			new &= ~WB_ERR_SEEN;
> +		}

Although we always want to clear out the SEEN bit if we're updating ... so

		new = (old & ~(MAX_ERRNO | WB_ERR_SEEN) | -err;

		/* Only increment if someone has looked at it */
		if (old & WB_ERR_SEEN)
			new += WB_ERR_CTR_INC;

... and then there's no need to update if it's the same errno and nobody's
seen it:

		if (old == new)
			break;

[...]

> +		/*
> +		 * We always store values with the "seen" bit set, so if this
> +		 * matches what we already have, then we can call it done.
> +		 * There is nothing to update so just return 0.
> +		 */
> +		if (old == file->f_wb_err)
> +			break;
> +
> +		/* set flag and try to swap it into place */
> +		new = old | WB_ERR_SEEN;

Again, I think we should avoid the cmpxchg with:

		if (old == new)
			break;

> +		cur = cmpxchg(&mapping->wb_err, old, new);
> +
> +		/*
> +		 * We can quit now if we successfully swapped in the new value
> +		 * or someone else beat us to it with the same value that we
> +		 * were planning to store.
> +		 */
> +		if (likely(cur == old || cur == new)) {
> +			file->f_wb_err = new;
> +			err = -(new & MAX_ERRNO);
> +			break;
> +		}
> +
> +		/* Raced with an update, try again */
> +		old = cur;

Well ... should we?  We're returning an error which is new to this fd anyway.
Do we want to return the most recent error by a nanosecond, or should we
return the previous one and then see this one next time we call fsync()?

I'd lean towards not looping here; not even looking at 'cur'.
