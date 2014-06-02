From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: handle symlink properly with inline_data
Date: Mon, 2 Jun 2014 10:56:31 -0400
Message-ID: <20140602145631.GD30598@thunk.org>
References: <1401709168-27403-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ian Nartowicz <claws@nartowicz.co.uk>,
	Tao Ma <tm@tao.ma>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45606 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbaFBO4q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2014 10:56:46 -0400
Content-Disposition: inline
In-Reply-To: <1401709168-27403-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2014 at 07:39:28PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit tries to fix a bug that we can't read symlink properly with
> inline data feature when the length of symlink is greater than 60 bytes
> but less than extra space....

Applied, thanks.

> +	if (ext4_has_inline_data(inode))
> +		return 0;
> +

I am wondering though, as we add ext4_has_inline_data() to more and
more codepaths, whether we might be better off making this an inline
function in ext4.h.  We should see how much such a change bloats the
text sizes, and whether there is any measurable CPU difference.

Cheers,

						- Ted
