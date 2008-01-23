From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 23/49] Add buffer head related helper functions
Date: Wed, 23 Jan 2008 14:06:48 -0800
Message-ID: <20080123140648.788fbc49.akpm@linux-foundation.org>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
	<1200970948-17903-8-git-send-email-tytso@mit.edu>
	<1200970948-17903-9-git-send-email-tytso@mit.edu>
	<1200970948-17903-10-git-send-email-tytso@mit.edu>
	<1200970948-17903-11-git-send-email-tytso@mit.edu>
	<1200970948-17903-12-git-send-email-tytso@mit.edu>
	<1200970948-17903-13-git-send-email-tytso@mit.edu>
	<1200970948-17903-14-git-send-email-tytso@mit.edu>
	<1200970948-17903-15-git-send-email-tytso@mit.edu>
	<1200970948-17903-16-git-send-email-tytso@mit.edu>
	<1200970948-17903-17-git-send-email-tytso@mit.edu>
	<1200970948-17903-18-git-send-email-tytso@mit.edu>
	<1200970948-17903-19-git-send-email-tytso@mit.edu>
	<1200970948-17903-20-git-send-email-tytso@mit.edu>
	<1200970948-17903-21-git-send-email-tytso@mit.edu>
	<1200970948-17903-22-git-send-email-tytso@mit.edu>
	<1200970948-17903-23-git-send-email-tytso@mit.edu>
	<1200970948-17903-24-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755366AbYAWWHN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 17:07:13 -0500
In-Reply-To: <1200970948-17903-24-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, 21 Jan 2008 22:02:02 -0500 "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> +}
> +EXPORT_SYMBOL(bh_uptodate_or_lock);
> +/**

Missing newline.

> + * bh_submit_read: Submit a locked buffer for reading
> + * @bh: struct buffer_head
> + *
> + * Returns a negative error
> + */
> +int bh_submit_read(struct buffer_head *bh)
> +{
> +	if (!buffer_locked(bh))
> +		lock_buffer(bh);
> +
> +	if (buffer_uptodate(bh))
> +		return 0;

Here it can lock the buffer then return zero

> +	get_bh(bh);
> +	bh->b_end_io = end_buffer_read_sync;
> +	submit_bh(READ, bh);
> +	wait_on_buffer(bh);
> +	if (buffer_uptodate(bh))
> +		return 0;

Here it will unlock the buffer and return zero.

This function is unusable when passed an unlocked buffer.

The return value should (always) be documented.

> +	return -EIO;
> +}
> +EXPORT_SYMBOL(bh_submit_read);
>  void __init buffer_init(void)

Missing newline.
