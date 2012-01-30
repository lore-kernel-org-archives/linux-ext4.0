From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bigalloc ENOSPC woes
Date: Mon, 30 Jan 2012 17:31:11 -0500
Message-ID: <20120130223111.GA20940@thunk.org>
References: <4F270949.30800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40016 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab2A3WbP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jan 2012 17:31:15 -0500
Content-Disposition: inline
In-Reply-To: <4F270949.30800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 30, 2012 at 03:19:05PM -0600, Eric Sandeen wrote:
> I got nervous when I tried this on an -O bigalloc -C 65536 fs:
> 
> # echo foo > blah; du -hc blah; sync; du -hc blah
> 4.0K blah
> 4.0K total
> 64K blah
> 64K total
> 
> Seems that du should never report less than the cluster size, should it?

Yes, that seems like a bug.

> And that made me wonder about ENOSPC handling - are we tracing
> delalloc allocations correctly?
> 
> From running xfstest 204 on a similarly-created fs, it really seems
> that we are not....
> 
> Ted, are you aware of those issues in bigalloc?

No, this is news to me.  I'll have to take a closer look at this;
thanks for bring this up.

						- Ted
