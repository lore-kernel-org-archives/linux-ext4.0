From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH] Filesystem Journal Notifications
Date: Sat, 20 Sep 2008 07:15:37 +0200
Message-ID: <20080920051537.GC9633@atrey.karlin.mff.cuni.cz>
References: <20080912220649.GB26999@apaithan-desktop.sanmateo.corp.akamai.com> <20080915023126.GF4090@webber.adilger.int> <20080915053937.GG4090@webber.adilger.int> <20080915193648.GC31055@apaithan-desktop.sanmateo.corp.akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jamie Lokier <jamie@shareable.org>,
	Dave Chinner <david@fromorbit.com>
To: Abhijit Paithankar <apaithan@akamai.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080915193648.GC31055@apaithan-desktop.sanmateo.corp.akamai.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

> I have used inotify simply because it is a mechanism that already exists
> in the kernel and is easily extensible.
> 
> The use of transaction ids as "journal cookie" was done to simplify
> things. A journal transaction ID is a readily available monotonically
> increasing ID unique to that partition (super block).
> 
> Journal cookies themselves are completely opaque to the application
> and as long as it is a monotonically increasing number that signifies
> a journal commit, it could be anything that a file system chooses it
> to be.
> 
> Ext3/Ext4 gather multiple changes into a single transaction. So,
> you will see a single 'commit' notification for multiple of meta-data
> changes. The 'commit' messages, therefore, won't be that many.
  I have quite some comments (additional to Andreas') to the coding
style but let's put them aside (they can be easily fixed) and first
solve some more fundamental problems:
  1) At the first sight it seems to be a useful idea to send to
userspace notifications when some change is safely on disk. But at the
second sight, it's technically really not that simple as it may seem.
Filesystems such as ext2 have no good way of providing such information,
even ext4 with delayed allocation has no way of giving you such
information for writes and I guess similar thing holds for xfs. Also log
structured filesystems and similar can tell you when a change is safely
on disk but have no concept of something like journal commit. So at this
point one should really ask himself whether a feature having a chance to
work only on a limited number of setups has a serious chance of being
used by application developpers...
  Also note that on ext3 and ext4 a single 'write' call from userspace
can be split among several transactions but there's just one inotify
event so this has to be taken care of.
  2) If I've understood correctly, you append to the name in the inotify
event the journal cookie. Sorry, but that is a really ugly hack,
definitely not a way how an interface to the userspace should look like.
Actually, the 'cookie' argument of inotify seems to quite match your
needs - it is supposed to be used for connecting related events and that
is exactly what you need. The only problem with this is that rename
already uses the cookie and so you cannot change it arbitrarily.
  3) Using just a single inode for commit notification is ugly and as
Andreas said not even workable in some cases. A sensible semantics here
could be that you'd simply send "changes safely on disk" event to all
inodes where some change went to disk. That still might have some
technical issues (like being too slow, having to identify which inodes
should get the event etc.) but would at least look sound from the
logical point of view.

  I'm sorry to turn your ideas down like this. I still appreciate
you're trying to improve Linux :). Thanks.

								Honza

> This patch (v2):
> 
> In this version of the patch I've done away with most of the file-system
> specific changes. The file system now only needs to send out a journal
> commit notification.
> 
> The 'journal cookie' is simply a u64 that increases every time a journal
> 'commit' is made. This will make the code more portable to other file
> systems.
> 
> Also, we no longer need those many journal message types. We can easily
> piggy-back on top of fsnotify. The only remaining one is
> IN_JOURNAL_COMMIT.
> 
> My next step is to allow multiple registrations for JOURNAL_COMMIT
> notification. I will post that patch once it is ready.
> 
> Signed-off-by: Abhijit Paithankar <apaithan@akamai.com>
> ---
> 
>  fs/ext3/ext3_jbd.c       |    9 +++++
>  fs/ext4/ext4_jbd2.c      |    9 +++++
>  fs/inotify.c             |   17 ++++++---
>  fs/inotify_user.c        |   81 ++++++++++++++++++++++++++++++++++++++++++-----
>  fs/jbd/commit.c          |    1 
>  fs/jbd2/commit.c         |    1 
>  include/linux/fs.h       |    2 +
>  include/linux/fsnotify.h |   11 ++++++
>  include/linux/inotify.h  |   19 ++++++++++-
>  include/linux/jbd.h      |    1 
>  include/linux/jbd2.h     |    1 
>  11 files changed, 138 insertions(+), 14 deletions(-)
> 
> ---
> 
> 
> Index: linux-2.6/fs/ext3/ext3_jbd.c
> ===================================================================
> --- linux-2.6.orig/fs/ext3/ext3_jbd.c	2008-09-15 10:12:25.000000000 -0700
> +++ linux-2.6/fs/ext3/ext3_jbd.c	2008-09-15 10:15:54.000000000 -0700
> @@ -3,6 +3,7 @@
>   */
>  
>  #include <linux/ext3_jbd.h>
> +#include <linux/fsnotify.h>
>  
>  int __ext3_journal_get_undo_access(const char *where, handle_t *handle,
>  				struct buffer_head *bh)
> @@ -57,3 +58,11 @@
>  		ext3_journal_abort_handle(where, __func__, bh, handle,err);
>  	return err;
>  }
> +
> +void journal_notify_commit (journal_t *journal)
> +{
> +	struct super_block *sb = journal->j_private;
> +	if (sb->s_priv_inode && sb->s_journal_cookie)
> +		fsnotify_journal_commit(sb);
> +}
> +
> Index: linux-2.6/fs/ext4/ext4_jbd2.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/ext4_jbd2.c	2008-09-15 10:14:12.000000000 -0700
> +++ linux-2.6/fs/ext4/ext4_jbd2.c	2008-09-15 10:15:50.000000000 -0700
> @@ -2,6 +2,7 @@
>   * Interface between ext4 and JBD
>   */
>  
> +#include <linux/fsnotify.h>
>  #include "ext4_jbd2.h"
>  
>  int __ext4_journal_get_undo_access(const char *where, handle_t *handle,
> @@ -57,3 +58,11 @@
>  		ext4_journal_abort_handle(where, __func__, bh, handle, err);
>  	return err;
>  }
> +
> +void jbd2_journal_notify_commit (journal_t *journal)
> +{
> +	struct super_block *sb = journal->j_private;
> +	if (sb->s_priv_inode && sb->s_journal_cookie)
> +		fsnotify_journal_commit(sb);
> +}
> +
> Index: linux-2.6/fs/inotify.c
> ===================================================================
> --- linux-2.6.orig/fs/inotify.c	2008-09-15 10:12:29.000000000 -0700
> +++ linux-2.6/fs/inotify.c	2008-09-15 10:13:44.000000000 -0700
> @@ -231,7 +231,7 @@
>  				 struct inotify_watch *watch)
>  {
>  	remove_watch_no_event(watch, ih);
> -	ih->in_ops->handle_event(watch, watch->wd, IN_IGNORED, 0, NULL, NULL);
> +	ih->in_ops->handle_event(watch, watch->wd, IN_IGNORED, 0, NULL, NULL, 0);
>  }
>  EXPORT_SYMBOL_GPL(inotify_remove_watch_locked);
>  
> @@ -280,10 +280,17 @@
>  			       const char *name, struct inode *n_inode)
>  {
>  	struct inotify_watch *watch, *next;
> +	u64 journal_cookie = 0;
>  
>  	if (!inotify_inode_watched(inode))
>  		return;
>  
> +	if (mask & (IN_ATTRIB | IN_MOVE | IN_CREATE | IN_DELETE |
> +		    IN_DELETE_SELF | IN_MOVE_SELF)) {
> +		if (inode->i_sb && inode->i_sb->s_journal_cookie)
> +			journal_cookie = inode->i_sb->s_journal_cookie;
> +	}
> +
>  	mutex_lock(&inode->inotify_mutex);
>  	list_for_each_entry_safe(watch, next, &inode->inotify_watches, i_list) {
>  		u32 watch_mask = watch->mask;
> @@ -293,7 +300,7 @@
>  			if (watch_mask & IN_ONESHOT)
>  				remove_watch_no_event(watch, ih);
>  			ih->in_ops->handle_event(watch, watch->wd, mask, cookie,
> -						 name, n_inode);
> +						 name, n_inode, journal_cookie);
>  			mutex_unlock(&ih->mutex);
>  		}
>  	}
> @@ -409,7 +416,7 @@
>  			struct inotify_handle *ih= watch->ih;
>  			mutex_lock(&ih->mutex);
>  			ih->in_ops->handle_event(watch, watch->wd, IN_UNMOUNT, 0,
> -						 NULL, NULL);
> +						 NULL, NULL, 0);
>  			inotify_remove_watch_locked(ih, watch);
>  			mutex_unlock(&ih->mutex);
>  		}
> @@ -576,7 +583,7 @@
>  		mask_add = 1;
>  
>  	/* don't allow invalid bits: we don't want flags set */
> -	mask &= IN_ALL_EVENTS | IN_ONESHOT;
> +	mask &= IN_ALL_EVENTS | IN_ONESHOT | IN_JOURNAL_COMMIT;
>  	if (unlikely(!mask))
>  		return -EINVAL;
>  
> @@ -623,7 +630,7 @@
>  	int newly_watched;
>  
>  	/* don't allow invalid bits: we don't want flags set */
> -	mask &= IN_ALL_EVENTS | IN_ONESHOT;
> +	mask &= IN_ALL_EVENTS | IN_ONESHOT | IN_JOURNAL_COMMIT;
>  	if (unlikely(!mask))
>  		return -EINVAL;
>  	watch->mask = mask;
> Index: linux-2.6/fs/inotify_user.c
> ===================================================================
> --- linux-2.6.orig/fs/inotify_user.c	2008-09-15 10:12:34.000000000 -0700
> +++ linux-2.6/fs/inotify_user.c	2008-09-15 10:51:43.000000000 -0700
> @@ -185,7 +185,7 @@
>   * This function can sleep.
>   */
>  static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
> -						  const char *name)
> +						  const char *name, u64 journal_cookie)
>  {
>  	struct inotify_kernel_event *kevent;
>  
> @@ -204,6 +204,7 @@
>  
>  	if (name) {
>  		size_t len, rem, event_size = sizeof(struct inotify_event);
> +		size_t journal_cookie_sz;
>  
>  		/*
>  		 * We need to pad the filename so as to properly align an
> @@ -213,6 +214,10 @@
>  		 * simple and safe for all architectures.
>  		 */
>  		len = strlen(name) + 1;
> +		if (journal_cookie) {
> +			journal_cookie_sz = sizeof(u64);
> +			len = len + journal_cookie_sz;
> +		}
>  		rem = event_size - len;
>  		if (len > event_size) {
>  			rem = event_size - (len % event_size);
> @@ -225,13 +230,52 @@
>  			kmem_cache_free(event_cachep, kevent);
>  			return NULL;
>  		}
> -		memcpy(kevent->name, name, len);
> +		if (journal_cookie) {
> +			char *ch;
> +
> +			memcpy(kevent->name, name, strlen(name));
> +			ch = kevent->name;
> +			ch += strlen(name);
> +			memset(ch++, 0, 1);
> +			sprintf(ch, "%llu", journal_cookie);
> +		}
> +		else {
> +			memcpy(kevent->name, name, len);
> +		}
>  		if (rem)
>  			memset(kevent->name + len, 0, rem);
>  		kevent->event.len = len + rem;
>  	} else {
> -		kevent->event.len = 0;
> -		kevent->name = NULL;
> +		if (journal_cookie) {
> +			size_t len, rem, event_size = sizeof(struct inotify_event);
> +			size_t journal_cookie_sz = sizeof(u64);
> +			char *ch;
> +
> +			len = 1 + journal_cookie_sz;
> +			rem = event_size - len;
> +			if (len > event_size) {
> +				rem = event_size - (len % event_size);
> +				if (len % event_size == 0)
> +					rem = 0;
> +			}
> +
> +			kevent->name = kmalloc(len + rem, GFP_KERNEL);
> +			if (unlikely(!kevent->name)) {
> +				kmem_cache_free(event_cachep, kevent);
> +				return NULL;
> +			}
> +			memset(kevent->name, 0, 1);
> +			ch = kevent->name;
> +			ch += 1;
> +			sprintf(ch, "%llu", journal_cookie);
> +			if (rem)
> +				memset(kevent->name + len, 0, rem);
> +			kevent->event.len = len + rem;
> +		}
> +		else {
> +			kevent->event.len = 0;
> +			kevent->name = NULL;
> +		}
>  	}
>  
>  	return kevent;
> @@ -269,7 +313,7 @@
>   */
>  static void inotify_dev_queue_event(struct inotify_watch *w, u32 wd, u32 mask,
>  				    u32 cookie, const char *name,
> -				    struct inode *ignored)
> +				    struct inode *ignored, u64 journal_cookie)
>  {
>  	struct inotify_user_watch *watch;
>  	struct inotify_device *dev;
> @@ -280,11 +324,25 @@
>  
>  	mutex_lock(&dev->ev_mutex);
>  
> +	if (mask & IN_JOURNAL_COMMIT) {
> +		if (!(w->inode) || !(w->inode->i_sb)
> +			|| !(w->inode->i_sb->s_priv_inode)
> +			|| !(w->inode->i_sb->s_journal_cookie))
> +			goto out;
> +	}
>  	/* we can safely put the watch as we don't reference it while
>  	 * generating the event
>  	 */
> -	if (mask & IN_IGNORED || w->mask & IN_ONESHOT)
> +	if (mask & IN_IGNORED || w->mask & IN_ONESHOT) {
> +                if (w->mask & IN_JOURNAL_COMMIT) {
> +                        struct super_block *sb = NULL;
> +                        if (w->inode && w->inode->i_sb)
> +                                sb = w->inode->i_sb;
> +                        if (sb && sb->s_priv_inode)
> +                                sb->s_priv_inode = NULL;
> +                }
>  		put_inotify_watch(w); /* final put */
> +	}
>  
>  	/* coalescing: drop this event if it is a dupe of the previous */
>  	last = inotify_dev_get_last_event(dev);
> @@ -304,9 +362,9 @@
>  
>  	/* if the queue overflows, we need to notify user space */
>  	if (unlikely(dev->event_count == dev->max_events))
> -		kevent = kernel_event(-1, IN_Q_OVERFLOW, cookie, NULL);
> +		kevent = kernel_event(-1, IN_Q_OVERFLOW, cookie, NULL, 0);
>  	else
> -		kevent = kernel_event(wd, mask, cookie, name);
> +		kevent = kernel_event(wd, mask, cookie, name, journal_cookie);
>  
>  	if (unlikely(!kevent))
>  		goto out;
> @@ -686,6 +744,13 @@
>  	ret = inotify_find_update_watch(dev->ih, inode, mask);
>  	if (ret == -ENOENT)
>  		ret = create_watch(dev, inode, mask);
> +	if (ret >= 0) {
> +		if (mask & IN_JOURNAL_COMMIT) {
> +                        struct super_block *sb = inode->i_sb;
> +                        if (sb)
> +                                sb->s_priv_inode = inode;
> +		}
> +	}
>  	mutex_unlock(&dev->up_mutex);
>  
>  	path_put(&path);
> Index: linux-2.6/fs/jbd/commit.c
> ===================================================================
> --- linux-2.6.orig/fs/jbd/commit.c	2008-09-15 10:12:42.000000000 -0700
> +++ linux-2.6/fs/jbd/commit.c	2008-09-15 10:13:44.000000000 -0700
> @@ -928,6 +928,7 @@
>  	}
>  	spin_unlock(&journal->j_list_lock);
>  
> +	journal_notify_commit(journal);
>  	jbd_debug(1, "JBD: commit %d complete, head %d\n",
>  		  journal->j_commit_sequence, journal->j_tail_sequence);
>  
> Index: linux-2.6/fs/jbd2/commit.c
> ===================================================================
> --- linux-2.6.orig/fs/jbd2/commit.c	2008-09-15 10:14:00.000000000 -0700
> +++ linux-2.6/fs/jbd2/commit.c	2008-09-15 10:16:09.000000000 -0700
> @@ -990,6 +990,7 @@
>  	}
>  	spin_unlock(&journal->j_list_lock);
>  
> +	jbd2_journal_notify_commit(journal);
>  	jbd_debug(1, "JBD: commit %d complete, head %d\n",
>  		  journal->j_commit_sequence, journal->j_tail_sequence);
>  
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h	2008-09-15 10:12:47.000000000 -0700
> +++ linux-2.6/include/linux/fs.h	2008-09-15 10:13:44.000000000 -0700
> @@ -1106,6 +1106,8 @@
>  	char s_id[32];				/* Informational name */
>  
>  	void 			*s_fs_info;	/* Filesystem private info */
> +	u64			s_journal_cookie;	/* current journal cookie # */
> +	struct inode		*s_priv_inode;	/* used for journal notifications */
>  
>  	/*
>  	 * The next field is for VFS *only*. No filesystems have any business
> Index: linux-2.6/include/linux/fsnotify.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fsnotify.h	2008-09-15 10:12:53.000000000 -0700
> +++ linux-2.6/include/linux/fsnotify.h	2008-09-15 10:13:44.000000000 -0700
> @@ -34,6 +34,17 @@
>  	inotify_d_move(entry);
>  }
>  
> +static inline void fsnotify_journal_commit (struct super_block *sb)
> +{
> +	struct inode *inode;
> +	sb->s_journal_cookie += 1;
> +	if (sb->s_journal_cookie && sb->s_priv_inode) {
> +		inode = sb->s_priv_inode;
> +		inotify_inode_queue_event(inode, IN_JOURNAL_COMMIT, 0,
> +					  NULL, NULL);
> +	}
> +}
> +
>  /*
>   * fsnotify_move - file old_name at old_dir was moved to new_name at new_dir
>   */
> Index: linux-2.6/include/linux/inotify.h
> ===================================================================
> --- linux-2.6.orig/include/linux/inotify.h	2008-09-15 10:12:59.000000000 -0700
> +++ linux-2.6/include/linux/inotify.h	2008-09-15 10:13:44.000000000 -0700
> @@ -44,6 +44,23 @@
>  #define IN_Q_OVERFLOW		0x00004000	/* Event queued overflowed */
>  #define IN_IGNORED		0x00008000	/* File was ignored */
>  
> +/* This is a journal commit event for file systems. These events are sent
> + * from a journaling filesystem or the journal itself.
> + *
> + * IN_JOURNAL_COMMIT is special in that only one file per journaling filesystem
> + * partition (super-block) is allowed. Registering for this event with multiple
> + * files will overwrite previous registrations. The last registration for this
> + * event will be taken as current and commit notifications will be delivered
> + * for that inode only.
> + *
> + * The inode registered for this event should not be unlinked. This will disable
> + * any further journal commit notifications.
> + *
> + * If this event is not registered for, journal commit messages will not be
> + * delivered
> + */
> +#define IN_JOURNAL_COMMIT	0x00010000	/* Journal on this superblock has committed a transaction */
> +
>  /* helper events */
>  #define IN_CLOSE		(IN_CLOSE_WRITE | IN_CLOSE_NOWRITE) /* close */
>  #define IN_MOVE			(IN_MOVED_FROM | IN_MOVED_TO) /* moves */
> @@ -97,7 +114,7 @@
>  
>  struct inotify_operations {
>  	void (*handle_event)(struct inotify_watch *, u32, u32, u32,
> -			     const char *, struct inode *);
> +			     const char *, struct inode *, u64);
>  	void (*destroy_watch)(struct inotify_watch *);
>  };
>  
> Index: linux-2.6/include/linux/jbd.h
> ===================================================================
> --- linux-2.6.orig/include/linux/jbd.h	2008-09-15 10:13:08.000000000 -0700
> +++ linux-2.6/include/linux/jbd.h	2008-09-15 10:13:44.000000000 -0700
> @@ -114,6 +114,7 @@
>   * This is an opaque datatype.
>   **/
>  typedef struct journal_s	journal_t;	/* Journal control structure */
> +extern void journal_notify_commit(journal_t *journal);
>  #endif
>  
>  /*
> Index: linux-2.6/include/linux/jbd2.h
> ===================================================================
> --- linux-2.6.orig/include/linux/jbd2.h	2008-09-15 10:16:18.000000000 -0700
> +++ linux-2.6/include/linux/jbd2.h	2008-09-15 10:16:45.000000000 -0700
> @@ -115,6 +115,7 @@
>   * This is an opaque datatype.
>   **/
>  typedef struct journal_s	journal_t;	/* Journal control structure */
> +extern void jbd2_journal_notify_commit(journal_t *journal);
>  #endif
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
