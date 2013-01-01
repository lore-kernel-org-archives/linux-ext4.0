From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 v2] debugfs: dump a sparse file as a new sparse file
Date: Tue, 1 Jan 2013 15:38:58 -0500
Message-ID: <20130101203858.GB12554@thunk.org>
References: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
 <1357043415-24668-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, George Spelvin <linux@horizon.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41224 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab3AAUjD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jan 2013 15:39:03 -0500
Content-Disposition: inline
In-Reply-To: <1357043415-24668-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 01, 2013 at 08:30:15PM +0800, Zheng Liu wrote:
> +errcode_t ext2fs_file_read2(ext2_file_t file, void *buf,
> +			    unsigned int wanted, unsigned int *got,
> +			    ext2_off64_t *seek)

I'm a bit concenred about this abstraction.  Consider what happens if
wanted is greater than a block size --- for example, consider if
wanted is 16k, and every other 1k block is uninitialized.

Then ext2fs_file_read2() will return *got set to 8k, and *seek set to
8k, and the buffer will contain the blocks that are initialized packed
up right against each other.

Worse, ext2fs_file_read() will do the same thing, so this commit
changes how ext2fs_file_read() functions, and a program which expects
to get the correct contents from the file will malfunction.

       	   	   	    	     	       - Ted
