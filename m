From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: don't re-try to remove the entry from es tree when
 we encounter a ENOMEM in ext4_ext_truncate
Date: Thu, 1 Aug 2013 01:45:01 -0700
Message-ID: <20130801084501.GA9419@infradead.org>
References: <1374753397-26432-1-git-send-email-wenqing.lz@taobao.com>
 <20130729154239.GD11816@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3HAIpE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 04:45:04 -0400
Content-Disposition: inline
In-Reply-To: <20130729154239.GD11816@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 11:42:39AM -0400, Theodore Ts'o wrote:
> The problem with truncate is that the VFS assumes truncate() will
> always succeed (the method function is returns a void, so there isn't
> even a way to propagate an error code back p to the VFS), so we really
> do need to do a retry in ext4's truncate code.

It hasn't for a long time.  The ill suite truncate method is gone for
a long time, and setattr can return errors just fine.

