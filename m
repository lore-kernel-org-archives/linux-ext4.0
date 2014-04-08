From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2/3: check the acl's validity before setting
Date: Tue, 8 Apr 2014 11:30:09 -0400
Message-ID: <20140408153009.GB31558@thunk.org>
References: <1396922030-4800-1-git-send-email-zhenzhang.zhang@huawei.com>
 <53435919.7000509@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: ZhangZhen <zhenzhang.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51681 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277AbaDHPaQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2014 11:30:16 -0400
Content-Disposition: inline
In-Reply-To: <53435919.7000509@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2014 at 10:04:09AM +0800, ZhangZhen wrote:
> Before setting the acl, call posix_acl_valid() to check if it is
> valid or not.
> 
> Signed-off-by: zhang zhen <zhenzhang.zhang@huawei.com>

As Christoph noted, this isn't needed since this check is done in the
VFS.

						- Ted
