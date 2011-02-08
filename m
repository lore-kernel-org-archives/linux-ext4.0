From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] VFS: call synchronize_rcu after kill_sb.
Date: Tue, 08 Feb 2011 22:27:10 +0530
Message-ID: <87hbceqxax.fsf@linux.vnet.ibm.com>
References: <1296896481-3650-1-git-send-email-tm@tao.ma> <4D4FF040.9050707@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>, Tao Ma <tm@tao.ma>,
	Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:39661 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab1BHQ5Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Feb 2011 11:57:24 -0500
In-Reply-To: <4D4FF040.9050707@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 07 Feb 2011 15:14:40 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 02/05/2011 11:01 AM, Tao Ma wrote:
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > In fa0d7e3, we use rcu free inode instead of freeing the inode
> > directly. It causes a problem when we rmmod immediately after
> > we umount the volume[1].
> > 
> > So we need to call synchronize_rcu after we kill_sb so that
> > the inode is freed before we do rmmod. The idea is inspired
> > by Chris Mason[2]. I tested with ext4 by umount+rmmod and it
> > doesn't show any error by now.
> > 
> > 1. http://marc.info/?l=linux-fsdevel&m=129680863330185&w=2
> > 2. http://marc.info/?l=linux-fsdevel&m=129684698713709&w=2 
> > 
> > Cc: Nick Piggin <npiggin@kernel.dk>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Chris Mason <chris.mason@oracle.com>
> > Cc: Boaz Harrosh <bharrosh@panasas.com>
> > Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> > ---
> >  fs/super.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/super.c b/fs/super.c
> > index 74e149e..315bce9 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -177,6 +177,13 @@ void deactivate_locked_super(struct super_block *s)
> >  	struct file_system_type *fs = s->s_type;
> >  	if (atomic_dec_and_test(&s->s_active)) {
> >  		fs->kill_sb(s);
> > +		/*
> > +		 * We need to synchronize rcu here so that
> > +		 * the delayed rcu inode free can be executed
> > +		 * before we put_super.
> > +		 * https://bugzilla.kernel.org/show_bug.cgi?id=27652
> > +		 */
> > +		synchronize_rcu();
> >  		put_filesystem(fs);
> >  		put_super(s);
> >  	} else {
> 
> 
> Sorry for not testing sooner.
> 
> The above does not work I still get the exact same crash!!
> 
> Looking at the code for synchronize_rcu() it looks like it might not be
> enough. It looks like all it does is a memory barrier. But we need 
> something that will actually pump these pending releases.
> (I might be way off here)
> 
> BTW after I get the Warning from the kmem_cache_destroy:
> slab error in kmem_cache_destroy(): cache `exofs_inode_cache': Can't free all objects
> Call Trace: 
> 754efe08:  [<6007e9a6>] kmem_cache_destroy+0x82/0xca
> 754efe38:  [<7a9296ba>] exit_exofs+0x1a/0x1c [exofs]
> 754efe48:  [<60054c10>] sys_delete_module+0x1b9/0x217
> 754efee8:  [<60014d60>] handle_syscall+0x58/0x70
> 754eff08:  [<60024163>] userspace+0x2dd/0x38a
> 754effc8:  [<600126af>] fork_handler+0x62/0x69
> 
> 
> I also get a Kernel crash. I suspect it's when finally these
> free_rcu come and the module (and kmem_cache) are no longer there.
> 
> What to do? Nick?


http://lwn.net/Articles/217484/ explains how to wait for rcu callback to finish

-aneesh
