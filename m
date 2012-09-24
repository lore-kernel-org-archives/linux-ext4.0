From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 2/8 v2] ext4: add operations on extent status tree
Date: Mon, 24 Sep 2012 11:35:09 +0800
Message-ID: <20120924033509.GB6196@gmail.com>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <1345615545-26133-3-git-send-email-wenqing.lz@taobao.com>
 <20120919184114.GC28470@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60104 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2IXDYf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Sep 2012 23:24:35 -0400
Content-Disposition: inline
In-Reply-To: <20120919184114.GC28470@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 19, 2012 at 02:41:14PM -0400, Theodore Ts'o wrote:
> On Wed, Aug 22, 2012 at 02:05:39PM +0800, Zheng Liu wrote:
> > + * Extents status encompass delayed extents and extent locks
> 
> I've looked over this patch set, and as near as I can tell, we aren't
> (yet) using the extents status structure to do extent-level locking.
> I could imagine using that in the future so we aren't using i_data_sem
> to lock out the entire tree, so block allocations could happen in
> parallel, but that's not here yet.
> 
> Is there something I'm missing, or was something else meant by "extent
> locks" here?

Hi Ted,

In my plan, the first step for extent status tree is only to record
delay extent in memory.  It can simplify the implementation of fiemap
and bigalloc, and introduce lseek SEEK_DATA/SEEK_HOLE support.  That is
all I want to finish in first step.  I am very glad to see that these
patches has been applied into dev branch even though it still has some
problems.  I will look at these problem ASAP.

Indeed, in this patch set, extent-level locking is still not used
because that is my next step in my plan [1].  I will try to use it
after these patches are fully tested and applied.  Thanks.

1. http://www.spinics.net/lists/linux-fsdevel/msg56291.html

Regards,
Zheng
