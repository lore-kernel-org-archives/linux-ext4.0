From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] misc: Allow "-E" and "-O" options multiple times
Date: Sun, 10 Jul 2011 16:59:54 -0400
Message-ID: <20110710205954.GC5615@thunk.org>
References: <1310172544-18650-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jim Garlick <garlick@llnl.gov>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39480 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab1GJU77 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2011 16:59:59 -0400
Content-Disposition: inline
In-Reply-To: <1310172544-18650-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 08, 2011 at 06:49:03PM -0600, Andreas Dilger wrote:
> +errcode_t append_opts(char **old_opts, const char *added_opts)
> +{
> +	/* First string adds NUL, others add ',' */
> +	int newlen, oldlen = 0;
> +	errcode_t retval;
> +
> +	if (*old_opts != NULL)
> +		oldlen = strlen(*old_opts);
> +
> +	newlen = oldlen + strlen(added_opts) + 1;

Shouldn't this be "... + 2" instead?  Suppose old_opts is "foo", and
new_opts is "bar".  We need enough space for 8 characters: "foo,bar\0"

Also, can you do me a favor and rebase this patch series on top of the
most recent next branch of e2fsprogs.  The pass1b changes are going to
be impacted by the changes to support bigalloc which showed up in next
over the weekend.

Thanks!!

						- Ted
