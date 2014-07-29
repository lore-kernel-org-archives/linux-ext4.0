From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: refactor ext4_move_extents code base v2
Date: Tue, 29 Jul 2014 10:25:56 -0400
Message-ID: <20140729142556.GB2256@thunk.org>
References: <1406062822-2883-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34461 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbaG2OZ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2014 10:25:59 -0400
Content-Disposition: inline
In-Reply-To: <1406062822-2883-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 23, 2014 at 01:00:22AM +0400, Dmitry Monakhov wrote:
> ext4_move_extents is too complex for review. It has duplicate almost each funciton
> available in the rest of other codebase. It has useless artifical restriction
> orig_offset == donor_offset. But in fact logic of ext4_move_extents
> is very simple:

Thanks for working to clean this up.  ext4_move_extents() is a
complicated hot mess.


> +
> +int
> +ext4_swap_extents(handle_t *handle, struct inode *o_inode,
> +		     struct inode *d_inode, ext4_lblk_t o_off, ext4_lblk_t d_off,
> +		     ext4_lblk_t count, int *erp)
> +{
> +	struct ext4_ext_path *o_path = NULL;
> +	struct ext4_ext_path *d_path = NULL;
> +	int replaced_count = 0;

We should document when the locking requirements are for
ext4_swap_extents.  Better yet, there should an assertion here so we
BUG if the appropriate locks (i_data_sem, i_mutex, etc.) aren't taken.

Why are you using the parameter names o_off and d_off?  "off" can make
someone think of byte offsets (which is where my mind went at first).
Maybe o_lblk and d_lblk instead?

> +		/* ext4_split_extent_at() may retult in leaf extent split,
> +		 * path must to be revalidated. */
> +		if (split)
> +			goto  repeat;
                            ^^^
Whitespace?

> +		/* If extents has different length we have to update i_blocks */

Why would the extents ever have different lengths?  Should this
(already) be disallowed above?


> +	repeat:
> +		if (o_path) {
> +			ext4_ext_drop_refs(o_path);
> +			kfree(o_path);
> +			o_path = NULL;
> +		}
> +		if (d_path) {
> +			ext4_ext_drop_refs(d_path);
> +			kfree(d_path);
> +			d_path = NULL;
> +		}
> +		o_off += len;
> +		d_off += len;
> +		replaced_count += len;
> +		count -= len;
> +	}

Why not swap things so this reads:

		o_off += len;
		d_off += len;
		replaced_count += len;
		count -= len;
	repeat:
		if (o_path) {
			ext4_ext_drop_refs(o_path);
			kfree(o_path);
			o_path = NULL;
		}
		if (d_path) {
			ext4_ext_drop_refs(d_path);
			kfree(d_path);
			d_path = NULL;
		}
	}

This way we don't have to rely on len == 0, and in one of the places
where the code currently reads "{ len = 0; goto repeat; }", the len=0;
assignment can be dropped.

Cheers,

						- Ted
