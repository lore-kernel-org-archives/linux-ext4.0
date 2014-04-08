From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: check the acl's validity before setting
Date: Tue, 8 Apr 2014 03:40:25 -0700
Message-ID: <20140408104025.GA17915@infradead.org>
References: <1396922063-4879-1-git-send-email-zhenzhang.zhang@huawei.com>
 <534358CA.3050808@huawei.com>
 <20140408054625.GA28818@infradead.org>
 <5343BA84.3090905@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, tytso@mit.edu,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: ZhangZhen <zhenzhang.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53428 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbaDHKkc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2014 06:40:32 -0400
Content-Disposition: inline
In-Reply-To: <5343BA84.3090905@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2014 at 04:59:48PM +0800, ZhangZhen wrote:
> You are right, this patch is useless. I'm sorry for this spam mail.
> 
> But btrfs_set_acl checks the validity of the ACL too. Should we delete it?
> Another choice is we can check the validity in every fs tree, and delete the
> check from posix_acl_xattr_set.

Doing it in common code is the right thing.  I suspect btrfs having it
is an oversight, but please verify it with the btrfs maintainers.

