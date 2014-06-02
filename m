From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] debugfs: do not display fast symlink with inline data
Date: Mon, 2 Jun 2014 10:58:23 -0400
Message-ID: <20140602145823.GF30598@thunk.org>
References: <1401709241-27521-1-git-send-email-wenqing.lz@taobao.com>
 <1401709241-27521-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ian Nartowicz <claws@nartowicz.co.uk>,
	Tao Ma <tm@tao.ma>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45628 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbaFBO60 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2014 10:58:26 -0400
Content-Disposition: inline
In-Reply-To: <1401709241-27521-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2014 at 07:40:41PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After enabling symlink with inline data, stat command in debugfs will
> think an inode is a fast symlink.  This patch fixes this issue.

Applied, thanks.

					- Ted
