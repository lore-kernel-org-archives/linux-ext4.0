From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Do not try lock_acquire after handle made invalid
Date: Wed, 16 Jan 2008 15:59:58 -0800
Message-ID: <1200527999.3985.20.camel@localhost.localdomain>
References: <12004403661489-git-send-email-jonas.bonn@gmail.com>
	 <20080115155914.c72aaea9.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jonas Bonn <jonas.bonn@gmail.com>, sct@redhat.com,
	linux-ext4@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39534 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYAPX74 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jan 2008 18:59:56 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0GNxsuM023947
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2008 18:59:54 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0GNxsd9157340
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2008 18:59:54 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0GNxrx4016099
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2008 18:59:54 -0500
In-Reply-To: <20080115155914.c72aaea9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-01-15 at 15:59 -0800, Andrew Morton wrote:
> On Wed, 16 Jan 2008 00:39:26 +0100
> Jonas Bonn <jonas.bonn@gmail.com> wrote:
> 
> > This likely fixes the oops in __lock_acquire reported as:
> > 
> > http://www.kerneloops.org/raw.php?rawid=2753&msgid=
> > http://www.kerneloops.org/raw.php?rawid=2749&msgid=
> > 
> > In these reported oopses, start_this_handle is returning -EROFS.
> > 
> > Signed-off-by: Jonas Bonn <jonas.bonn@gmail.com>
> > ---
> >  fs/jbd/transaction.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> > index 08ff6c7..038ed74 100644
> > --- a/fs/jbd/transaction.c
> > +++ b/fs/jbd/transaction.c
> > @@ -288,10 +288,12 @@ handle_t *journal_start(journal_t *journal, int nblocks)
> >  		jbd_free_handle(handle);
> >  		current->journal_info = NULL;
> >  		handle = ERR_PTR(err);
> > +		goto out;
> >  	}
> >  
> >  	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> >  
> > +out:
> >  	return handle;
> >  }
> 
> Yeah, thanks.
> 
> It looks like we forgot to port this lockdep support into ext4.  This is
> bad.  What else got lost?

Here is the ext4/jbd2 port of the original lockdep patch with the above
fix. Please let me know if I missed anything.

It's likely there are other jbd/ext3 changes missed out in ext4/jbd2. I
will take a look at the git tree and do a cleanup.


Thanks for pointing this out.

---------------------------------------------------------
jbd2: lockdep support for jbd2
> Except lockdep doesn't know about journal_start(), which has ranking
> requirements similar to a semaphore.  

Ported from lockdep jbd patch.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/jbd2/transaction.c |   11 +++++++++++
 include/linux/jbd2.h  |    4 ++++
 2 files changed, 15 insertions(+)

Index: linux-2.6.24-rc7/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.24-rc7.orig/fs/jbd2/transaction.c	2008-01-16 15:30:24.000000000 -0800
+++ linux-2.6.24-rc7/fs/jbd2/transaction.c	2008-01-16 15:41:14.000000000 -0800
@@ -241,6 +241,8 @@ out:
 	return ret;
 }
 
+static struct lock_class_key jbd2_handle_key;
+
 /* Allocate a new handle.  This should probably be in a slab... */
 static handle_t *new_handle(int nblocks)
 {
@@ -251,6 +253,9 @@ static handle_t *new_handle(int nblocks)
 	handle->h_buffer_credits = nblocks;
 	handle->h_ref = 1;
 
+	lockdep_init_map(&handle->h_lockdep_map, "jbd2_handle",
+						&jbd2_handle_key, 0);
+
 	return handle;
 }
 
@@ -293,7 +298,11 @@ handle_t *jbd2_journal_start(journal_t *
 		jbd2_free_handle(handle);
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
+		goto out;
 	}
+
+	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+out:
 	return handle;
 }
 
@@ -1419,6 +1428,8 @@ int jbd2_journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
+	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+
 	jbd2_free_handle(handle);
 	return err;
 }
Index: linux-2.6.24-rc7/include/linux/jbd2.h
===================================================================
--- linux-2.6.24-rc7.orig/include/linux/jbd2.h	2008-01-16 15:29:03.000000000 -0800
+++ linux-2.6.24-rc7/include/linux/jbd2.h	2008-01-16 15:29:54.000000000 -0800
@@ -418,6 +418,10 @@ struct handle_s
 	unsigned int	h_sync:		1;	/* sync-on-close */
 	unsigned int	h_jdata:	1;	/* force data journaling */
 	unsigned int	h_aborted:	1;	/* fatal error on handle */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	h_lockdep_map;
+#endif
 };
 
 
