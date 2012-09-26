From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Wed, 26 Sep 2012 11:24:26 +0800
Message-ID: <20120926032426.GA496@gmail.com>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
 <20120919190541.GE28470@thunk.org>
 <20120925124252.GA1518@gmail.com>
 <20120925205921.GA8625@thunk.org>
 <20120926020955.GA4101@gmail.com>
 <20120926024745.GA11468@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36448 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2IZDNu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2012 23:13:50 -0400
Content-Disposition: inline
In-Reply-To: <20120926024745.GA11468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 25, 2012 at 10:47:45PM -0400, Theodore Ts'o wrote:
> On Wed, Sep 26, 2012 at 10:09:55AM +0800, Zheng Liu wrote:
> > On Tue, Sep 25, 2012 at 04:59:21PM -0400, Theodore Ts'o wrote:
> > > On Tue, Sep 25, 2012 at 08:42:52PM +0800, Zheng Liu wrote:
> > > > > If so, we might want to think about adding a sanity check to make sure
> > > > > that by the time we are done with the inode in ext4_evict_inode()
> > > > > (after we have forced writeback), the ext4_es_tree is empty.  Agreed?
> > > > 
> > > > Today I revise this patch again, and I find extent_status_tree is freed
> > > > in ext4_clear_inode().  So maybe I don't think that we need to check
> > > > this tree to be freed in ext4_evict_inode().  This change is in this
> > > > patch '[RFC][PATCH 4/8 v2] ext4: let ext4 maintain extent status tree'.
> > > > What's your opinion?
> > > 
> > > When you say "revise this patch again", does that mean that you would
> > > like to submit a new set of patch series with changes?  Or just that
> > > you are looking at this patch set again?
> > 
> > Yes, I prepare to submit a new patch set.
> 
> Well, note that the merge window is opening *soon*.  I haven't yet
> moved the master branch, so I can update the patch set, but I'm going
> to need it soon.
> 
> Can you let me know what changes you need to make?  If it is to add
> new features or new sanity checks, does it make sense to simply make
> it as new commits to existing patch set?  Or are there fundamental
> problems with the current set, that would be better to fix in the
> current set of commits?  (Or is it just minor stylistic/spelling
> fixes?)
> 
> Thanks!!

In new patch set, there is three changes as beblow:

1. add a sanity check in ext4_evict_inode()
2. fix a bug in ext4_find_delalloc_range().  This bug is reported by
xfstest #230 when we enable bigalloc feature.
3. Add a new rwlock to protect extent status tree.

So I think that we can only add a sanity check and fix the bigalloc bug,
and then apply this patch set because the changes are minor.  For adding
a new lock to protect extent status tree, we can add this feature in a
new patch.  If you think it is OK, I can generate a new patch set, do
some tests using xfstest, and submit it as soon as possible.  What's
your opinion?

Regards,
Zheng
