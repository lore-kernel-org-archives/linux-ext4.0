From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix COLLAPSE RANGE test failure when bigalloc is
 enable
Date: Tue, 17 Jun 2014 18:09:00 -0400
Message-ID: <20140617220900.GJ24890@thunk.org>
References: <001001cf7fcc$34f3c2c0$9edb4840$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44182 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965777AbaFQWJH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 18:09:07 -0400
Content-Disposition: inline
In-Reply-To: <001001cf7fcc$34f3c2c0$9edb4840$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2014 at 05:08:45PM +0900, Namjae Jeon wrote:
> Blocks in collapse range should be collapsed per cluster unit when bigalloc
> is enable. If bigalloc is not enable, EXT4_CLUSTER_SIZE will be same with
> EXT4_BLOCK_SIZE.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Correct me if I'm wrong, but this patch enables COLLAPSE_RANGE when
bigalloc is enabled.  The commit description (and the one-line
summary) should emphasize this.

And I assume you've run a full xfstests auto run with bigalloc and
everything passed?

Thanks,

						- Ted
