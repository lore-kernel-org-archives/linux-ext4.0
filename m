From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Ext4: remove a useless check for the function
 ext4_data_block_valid
Date: Sat, 26 Jan 2013 10:38:26 -0500
Message-ID: <20130126153826.GB5887@thunk.org>
References: <51045F77.5000106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45572 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab3AZPi3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jan 2013 10:38:29 -0500
Content-Disposition: inline
In-Reply-To: <51045F77.5000106@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 26, 2013 at 02:57:59PM -0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Because it is no doubt 'start_blk + count < start_blk' always comes to
> false. It is useless to have this check,remove it.

Actually, it can be true --- if start_blk + count (which are both
unsigned integers) overflows....

					- Ted
