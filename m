From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] e2fsck: handle symlink properly with inline data
Date: Mon, 2 Jun 2014 10:58:13 -0400
Message-ID: <20140602145813.GE30598@thunk.org>
References: <1401709241-27521-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ian Nartowicz <claws@nartowicz.co.uk>,
	Tao Ma <tm@tao.ma>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45618 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbaFBO6R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2014 10:58:17 -0400
Content-Disposition: inline
In-Reply-To: <1401709241-27521-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2014 at 07:40:40PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After fixing a bug on kernel side for handling symlink properly with
> inline data, it will break the assumption in e2fsck because in original
> patch set of inline data it doesn't support symlink with inline data
> feature.  This commit makes e2fsck handle symlink properly with inline
> data.
> 
> After applied this patch, the inline data feature has ability to store
> the symlink.  We also need to add this ability for symlink commmand in
> debugfs.

Applied, thanks.

					- Ted
