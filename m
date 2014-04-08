From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: check the acl's validity before setting
Date: Mon, 7 Apr 2014 22:46:25 -0700
Message-ID: <20140408054625.GA28818@infradead.org>
References: <1396922063-4879-1-git-send-email-zhenzhang.zhang@huawei.com>
 <534358CA.3050808@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: ZhangZhen <zhenzhang.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaDHFqk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2014 01:46:40 -0400
Content-Disposition: inline
In-Reply-To: <534358CA.3050808@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2014 at 10:02:50AM +0800, ZhangZhen wrote:
> Before setting the acl, call posix_acl_valid() to check if it is
> valid or not.

Why? posix_acl_xattr_set already does that for you, and it's the only
way to feed in an ACL from userspace.

