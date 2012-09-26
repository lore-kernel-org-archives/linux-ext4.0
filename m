From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Wed, 26 Sep 2012 10:09:55 +0800
Message-ID: <20120926020955.GA4101@gmail.com>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
 <20120919190541.GE28470@thunk.org>
 <20120925124252.GA1518@gmail.com>
 <20120925205921.GA8625@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120925205921.GA8625@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 25, 2012 at 04:59:21PM -0400, Theodore Ts'o wrote:
> On Tue, Sep 25, 2012 at 08:42:52PM +0800, Zheng Liu wrote:
> > > If so, we might want to think about adding a sanity check to make sure
> > > that by the time we are done with the inode in ext4_evict_inode()
> > > (after we have forced writeback), the ext4_es_tree is empty.  Agreed?
> > 
> > Today I revise this patch again, and I find extent_status_tree is freed
> > in ext4_clear_inode().  So maybe I don't think that we need to check
> > this tree to be freed in ext4_evict_inode().  This change is in this
> > patch '[RFC][PATCH 4/8 v2] ext4: let ext4 maintain extent status tree'.
> > What's your opinion?
> 
> When you say "revise this patch again", does that mean that you would
> like to submit a new set of patch series with changes?  Or just that
> you are looking at this patch set again?

Yes, I prepare to submit a new patch set.

> 
> It's certainly true that ext4_evict_inode() will call
> ext4_clear_inode(), so it's not a question of worrying about a memory
> leak.  I was thinking more about doing this as a cheap sanity check
> for the data structure.  By the time we call ext4_evict_inode(), the
> mm layer all writeback should be complete.  Hence, all of the entries
> to the tree _should_ have been removed by the time we call
> ext4_evict_inode().
> 
> I don't know if this is going to change as you start using this data
> structure for other purposes (such as locking a range of pages), but
> if I understand how things are currently working, it _should_ be the
> case that when ext4_evict_inode() calls ext4_clear_inode(), the call
> to ext4_es_remove_extent() should be a no-op, since all of the nodes
> in the extent status tree should have been released by then.  If it
> isn't, then either I'm not understanding the code, or there's a bug in
> the code.

Yes, you are right.  In currently implementation, extent status tree
only maintains the status of delay extents.  So in ext4_evict_inode()
extent status tree should be an empty tree.  I will add a sanity check
to ensure it.  Thanks for your explanation.

Regards,
Zheng
