From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] ext4: change return value from int to ssize_t
 in ext4_file_write
Date: Mon, 28 May 2012 18:08:21 -0400
Message-ID: <20120528220821.GC5610@thunk.org>
References: <20120412202029.GB19808@quack.suse.cz>
 <1334280157-11630-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, jouni.siren@iki.fi, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46076 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab2E1WIg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 18:08:36 -0400
Content-Disposition: inline
In-Reply-To: <1334280157-11630-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 09:22:37AM +0800, Zheng Liu wrote:
> On 64-platform, when we do a write operation with a huge number of data, it
> will cause that the ret variable overflows.  So it is replaced with ssize_t.
> 
> Reported-by: Jouni Siren <jouni.siren@iki.fi>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied, with the following commit description:

   ext4: use consistent ssize_t type in ext4_file_write()

   The generic_file_aio_write() function returns ssize_t, and
   ext4_file_write() returns a ssize_t, so use a ssize_t to collect the
   return value from generic_file_aio_write().  It shouldn't matter since
   the VFS read/write paths shouldn't allow a read greater than MAX_INT,
   but there was previously a bug in the AIO code paths, and it's best if
   we use a consistent type so that the return value from
   generic_file_aio_write() can't get truncated.

Regards,

					- Ted
