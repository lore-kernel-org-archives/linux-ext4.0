From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] v2.6.38-rc3+ BUG when calling destroy_inodecache at module unload
Date: Fri, 04 Feb 2011 14:15:17 -0500
Message-ID: <1296846886-sup-1431@think>
References: <4D4AF928.9030609@panasas.com> <4D4BBAAB.4070500@tao.ma>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Boaz Harrosh <bharrosh@panasas.com>,
	Nick Piggin <npiggin@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:45566 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab1BDTQJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Feb 2011 14:16:09 -0500
In-reply-to: <4D4BBAAB.4070500@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excerpts from Tao Ma's message of 2011-02-04 03:36:59 -0500:
> On 02/04/2011 02:51 AM, Boaz Harrosh wrote:
> > Last good Kernel was 2.6.37
> > I'm doing a "mount" then "unmount". I think root is the only created inode.
> > rmmod is called immediately after "unmount" within a script
> >
> > if I only do unmount and manually call "modprobe --remove exofs" after a small while
> > all is fine.
> >
> > I get:
> > slab error in kmem_cache_destroy(): cache `exofs_inode_cache': Can't free all objects
> > Call Trace:
> > 77dfde08:  [<6007e9a6>] kmem_cache_destroy+0x82/0xca
> > 77dfde38:  [<7c1fa3da>] exit_exofs+0x1a/0x1c [exofs]
> > 77dfde48:  [<60054c10>] sys_delete_module+0x1b9/0x217
> > 77dfdee8:  [<60014d60>] handle_syscall+0x58/0x70
> > 77dfdf08:  [<60024163>] userspace+0x2dd/0x38a
> > 77dfdfc8:  [<600126af>] fork_handler+0x62/0x69
> >    
> I also get a similar error when testing ext4 and a bug is opened there.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=27652
> 
> And I have done some simple investigation for ext4 and It looks as if now with the new *fs_i_callback doesn't free the inode to *fs_inode_cache immediately. So the old logic will destroy the inode cache before we free all the inode object.
> 
> Since there are more than one fs affected by this, we may need to find a way in the VFS.

Sounds like we just need a synchronize_rcu call before we delete the
cache?

-chris
