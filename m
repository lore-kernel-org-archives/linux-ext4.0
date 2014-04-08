From: ZhangZhen <zhenzhang.zhang@huawei.com>
Subject: Re: [PATCH] ext4: check the acl's validity before setting
Date: Tue, 8 Apr 2014 16:59:48 +0800
Message-ID: <5343BA84.3090905@huawei.com>
References: <1396922063-4879-1-git-send-email-zhenzhang.zhang@huawei.com> <534358CA.3050808@huawei.com> <20140408054625.GA28818@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	<linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:36229 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaDHJEi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2014 05:04:38 -0400
In-Reply-To: <20140408054625.GA28818@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2014/4/8 13:46, Christoph Hellwig wrote:
> On Tue, Apr 08, 2014 at 10:02:50AM +0800, ZhangZhen wrote:
>> Before setting the acl, call posix_acl_valid() to check if it is
>> valid or not.
> 
> Why? posix_acl_xattr_set already does that for you, and it's the only
> way to feed in an ACL from userspace.
> 
> 
> 
Hi Hellwig,

You are right, this patch is useless. I'm sorry for this spam mail.

But btrfs_set_acl checks the validity of the ACL too. Should we delete it?
Another choice is we can check the validity in every fs tree, and delete the
check from posix_acl_xattr_set.

How should we do?

Thanks!


