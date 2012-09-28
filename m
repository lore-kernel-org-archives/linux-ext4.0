From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Fri, 28 Sep 2012 15:27:14 +0800
Message-ID: <20120928072714.GA8544@gmail.com>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
 <20120919190541.GE28470@thunk.org>
 <20120925124252.GA1518@gmail.com>
 <20120925205921.GA8625@thunk.org>
 <20120926020955.GA4101@gmail.com>
 <20120926024745.GA11468@thunk.org>
 <20120926032426.GA496@gmail.com>
 <20120926033740.GC11468@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55186 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab2I1HQh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2012 03:16:37 -0400
Content-Disposition: inline
In-Reply-To: <20120926033740.GC11468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 25, 2012 at 11:37:40PM -0400, Theodore Ts'o wrote:
> On Wed, Sep 26, 2012 at 11:24:26AM +0800, Zheng Liu wrote:
> > > Can you let me know what changes you need to make?  If it is to add
> > > new features or new sanity checks, does it make sense to simply make
> > > it as new commits to existing patch set?  Or are there fundamental
> > > problems with the current set, that would be better to fix in the
> > > current set of commits?  (Or is it just minor stylistic/spelling
> > > fixes?)
> > > 
> > > Thanks!!
> > 
> > In new patch set, there is three changes as beblow:
> > 
> > 1. add a sanity check in ext4_evict_inode()
> > 2. fix a bug in ext4_find_delalloc_range().  This bug is reported by
> > xfstest #230 when we enable bigalloc feature.
> > 3. Add a new rwlock to protect extent status tree.
> > 
> > So I think that we can only add a sanity check and fix the bigalloc bug,
> > and then apply this patch set because the changes are minor.  For adding
> > a new lock to protect extent status tree, we can add this feature in a
> > new patch.  If you think it is OK, I can generate a new patch set, do
> > some tests using xfstest, and submit it as soon as possible.  What's
> > your opinion?
> 
> Do you think you can get me the patches by the end of the week?  If
> so, that should work.

Hi Ted,

Until now, I have fixed the bigalloc bug that is reported by xfstest
#230, and merged Hugh's patch.  But I do really think that this patch
set couldn't be applied at this merge window because the change is not
*minor*, and it still needs to do more tests.  That would be great if
you can keep this patch set in dev branch at this merge window.  Thanks!

Regards,
Zheng
