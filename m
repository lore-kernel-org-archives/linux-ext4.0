From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V6 RESEND 01/15] ext4: add a function which extends a
 group without checking parameters
Date: Tue, 3 Jan 2012 16:07:48 -0500
Message-ID: <20120103210748.GE30502@thunk.org>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
 <1325242812-27005-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36844 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab2ADDtd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 22:49:33 -0500
Content-Disposition: inline
In-Reply-To: <1325242812-27005-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 30, 2011 at 06:59:58PM +0800, Yongqiang Yang wrote:
> +static int ext4_group_extend_no_check(struct super_block *sb,
> +			ext4_fsblk_t o_blocks_count, ext4_grpblk_t add)

I fixed the whitespace here (nit-picky, I know)

> +	handle = ext4_journal_start_sb(sb, 3);
> +	if (IS_ERR(handle)) {
> +		err = PTR_ERR(handle);
> +		ext4_warning(sb, "error %d on journal start", err);
> +		goto out;
> +	}

There's only two calls "goto out", and out: currently is just "return
err;".  So I just changed this to be "return err", which is clearer.
I tend to place more imporance for clarity of the code than rigid
rules which say that there should only be one control flow such that
"return err" must only occur once at the end of the function.

> +	err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
> +	if (err) {
> +		ext4_warning(sb, "error %d on journal write access", err);
> +		ext4_journal_stop(handle);
> +		goto out;
> +	}

Instead of calling ext4_journal_stop() here, it's simpler just to jump
to the "exit_journal" label, which is consistent with what we do
everywhere else.  Now all of the error gotos are to "exit_journal",
which I've renamed to "errout".

These are minor stylistic changes, but I thought I would mention them
so that other people understand what is considered the best way to do
things, I've just made these changes myself to avoid asking you to
respin the patches.

Regards,

					- Ted
