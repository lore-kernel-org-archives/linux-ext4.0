From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: fix sphinx kerel-doc build warnings for journal_s
Date: Mon, 8 Jan 2018 16:16:04 +0100
Message-ID: <20180108151604.v4kfq47dc4cpcdxw@quack2.suse.cz>
References: <1515285974-29373-1-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Tobin C. Harding" <me@tobin.cc>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515285974-29373-1-git-send-email-me@tobin.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 07-01-18 11:46:14, Tobin C. Harding wrote:
> Sphinx emits various warnings when building make target 'htmldocs'.
> 
> Currently struct journal_s definition contains duplicate documentation,
> some as kernel-docs and some as standard c89 comments.  We can reduce
> duplication while cleaning up the kernel-docs. 
> 
> Move all kernel-docs to right above each struct member.  Use the set of
> all existing comments (kernel-doc and c89).
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

This is probably better than having documentation in two places so:

Acked-by: Jan Kara <jack@suse.cz>

Just one nit below:

>  struct journal_s
>  {
> -	/* General journaling state flags [j_state_lock] */
> +	/**
> +	 * @j_flags:
> +	 *
> +	 * General journaling state flags [j_state_lock]
> +	 */

Won't it be possible in cases like this to fold the name and description
into one line? Like:

	/**
	 * @j_flags: General journaling state flags [j_state_lock]
	 */

That would save a lot of vertical space...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
