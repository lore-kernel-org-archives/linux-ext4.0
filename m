From: Jan Kara <jack@suse.com>
Subject: [PATCH 1/4] doc: Update doc about journalling layer
Date: Thu, 16 Jul 2015 11:53:03 +0200
Message-ID: <1437040386-31148-2-git-send-email-jack@suse.com>
References: <1437040386-31148-1-git-send-email-jack@suse.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437040386-31148-1-git-send-email-jack@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Documentation of journalling layer in
Documentation/DocBook/filesystems.tmpl speaks about JBD layer. Since
that is going away, update the documentation to speak about JBD2. Also
update the parts that have changed since someone last touched the
document and remove some parts which are just misleading and outdated.

Signed-off-by: Jan Kara <jack@suse.com>
---
 Documentation/DocBook/filesystems.tmpl | 178 +++++++++++++--------------------
 1 file changed, 67 insertions(+), 111 deletions(-)

diff --git a/Documentation/DocBook/filesystems.tmpl b/Documentation/DocBook/filesystems.tmpl
index bcdfdb9a9277..6006b6358c86 100644
--- a/Documentation/DocBook/filesystems.tmpl
+++ b/Documentation/DocBook/filesystems.tmpl
@@ -146,36 +146,30 @@
 The journalling layer is  easy to use. You need to
 first of all create a journal_t data structure. There are
 two calls to do this dependent on how you decide to allocate the physical
-media on which the journal resides. The journal_init_inode() call
-is for journals stored in filesystem inodes, or the journal_init_dev()
-call can be use for journal stored on a raw device (in a continuous range
+media on which the journal resides. The jbd2_journal_init_inode() call
+is for journals stored in filesystem inodes, or the jbd2_journal_init_dev()
+call can be used for journal stored on a raw device (in a continuous range
 of blocks). A journal_t is a typedef for a struct pointer, so when
-you are finally finished make sure you call journal_destroy() on it
+you are finally finished make sure you call jbd2_journal_destroy() on it
 to free up any used kernel memory.
 </para>
 
 <para>
 Once you have got your journal_t object you need to 'mount' or load the journal
-file, unless of course you haven't initialised it yet - in which case you
-need to call journal_create().
+file. The journalling layer expects the space for the journal was already
+allocated and initialized properly by the userspace tools.  When loading the
+journal you must call jbd2_journal_load() to process journal contents.  If the
+client file system detects the journal contents does not need to be processed
+(or even need not have valid contents), it may call jbd2_journal_wipe() to
+clear the journal contents before calling jbd2_journal_load().
 </para>
 
 <para>
-Most of the time however your journal file will already have been created, but
-before you load it you must call journal_wipe() to empty the journal file.
-Hang on, you say , what if the filesystem wasn't cleanly umount()'d . Well, it is the
-job of the client file system to detect this and skip the call to journal_wipe().
-</para>
-
-<para>
-In either case the next call should be to journal_load() which prepares the
-journal file for use. Note that journal_wipe(..,0) calls journal_skip_recovery()
-for you if it detects any outstanding transactions in the journal and similarly
-journal_load() will call journal_recover() if necessary.
-I would advise reading fs/ext3/super.c for examples on this stage.
-[RGG: Why is the journal_wipe() call necessary - doesn't this needlessly
-complicate the API. Or isn't a good idea for the journal layer to hide
-dirty mounts from the client fs]
+Note that jbd2_journal_wipe(..,0) calls jbd2_journal_skip_recovery() for you if
+it detects any outstanding transactions in the journal and similarly
+jbd2_journal_load() will call jbd2_journal_recover() if necessary.  I would
+advise reading ext4_load_journal() in fs/ext4/super.c for examples on this
+stage.
 </para>
 
 <para>
@@ -189,41 +183,41 @@ You still need to actually journal your filesystem changes, this
 is done by wrapping them into transactions. Additionally you
 also need to wrap the modification of each of the buffers
 with calls to the journal layer, so it knows what the modifications
-you are actually making are. To do this use  journal_start() which
+you are actually making are. To do this use jbd2_journal_start() which
 returns a transaction handle.
 </para>
 
 <para>
-journal_start()
-and its counterpart journal_stop(), which indicates the end of a transaction
-are nestable calls, so you can reenter a transaction if necessary,
-but remember you must call journal_stop() the same number of times as
-journal_start() before the transaction is completed (or more accurately
-leaves the update phase). Ext3/VFS makes use of this feature to simplify
-quota support.
+jbd2_journal_start()
+and its counterpart jbd2_journal_stop(), which indicates the end of a
+transaction are nestable calls, so you can reenter a transaction if necessary,
+but remember you must call jbd2_journal_stop() the same number of times as
+jbd2_journal_start() before the transaction is completed (or more accurately
+leaves the update phase). Ext4/VFS makes use of this feature to simplify
+handling of inode dirtying, quota support, etc.
 </para>
 
 <para>
 Inside each transaction you need to wrap the modifications to the
 individual buffers (blocks). Before you start to modify a buffer you
-need to call journal_get_{create,write,undo}_access() as appropriate,
+need to call jbd2_journal_get_{create,write,undo}_access() as appropriate,
 this allows the journalling layer to copy the unmodified data if it
 needs to. After all the buffer may be part of a previously uncommitted
 transaction.
 At this point you are at last ready to modify a buffer, and once
-you are have done so you need to call journal_dirty_{meta,}data().
+you are have done so you need to call jbd2_journal_dirty_{meta,}data().
 Or if you've asked for access to a buffer you now know is now longer
-required to be pushed back on the device you can call journal_forget()
+required to be pushed back on the device you can call jbd2_journal_forget()
 in much the same way as you might have used bforget() in the past.
 </para>
 
 <para>
-A journal_flush() may be called at any time to commit and checkpoint
+A jbd2_journal_flush() may be called at any time to commit and checkpoint
 all your transactions.
 </para>
 
 <para>
-Then at umount time , in your put_super() you can then call journal_destroy()
+Then at umount time , in your put_super() you can then call jbd2_journal_destroy()
 to clean up your in-core journal object.
 </para>
 
@@ -231,53 +225,68 @@ to clean up your in-core journal object.
 Unfortunately there a couple of ways the journal layer can cause a deadlock.
 The first thing to note is that each task can only have
 a single outstanding transaction at any one time, remember nothing
-commits until the outermost journal_stop(). This means
+commits until the outermost jbd2_journal_stop(). This means
 you must complete the transaction at the end of each file/inode/address
 etc. operation you perform, so that the journalling system isn't re-entered
 on another journal. Since transactions can't be nested/batched
 across differing journals, and another filesystem other than
-yours (say ext3) may be modified in a later syscall.
+yours (say ext4) may be modified in a later syscall.
 </para>
 
 <para>
-The second case to bear in mind is that journal_start() can
+The second case to bear in mind is that jbd2_journal_start() can
 block if there isn't enough space in the journal for your transaction
 (based on the passed nblocks param) - when it blocks it merely(!) needs to
 wait for transactions to complete and be committed from other tasks,
-so essentially we are waiting for journal_stop(). So to avoid
-deadlocks you must treat journal_start/stop() as if they
+so essentially we are waiting for jbd2_journal_stop(). So to avoid
+deadlocks you must treat jbd2_journal_start/stop() as if they
 were semaphores and include them in your semaphore ordering rules to prevent
-deadlocks. Note that journal_extend() has similar blocking behaviour to
-journal_start() so you can deadlock here just as easily as on journal_start().
+deadlocks. Note that jbd2_journal_extend() has similar blocking behaviour to
+jbd2_journal_start() so you can deadlock here just as easily as on
+jbd2_journal_start().
 </para>
 
 <para>
 Try to reserve the right number of blocks the first time. ;-). This will
 be the maximum number of blocks you are going to touch in this transaction.
-I advise having a look at at least ext3_jbd.h to see the basis on which
-ext3 uses to make these decisions.
+I advise having a look at at least ext4_jbd.h to see the basis on which
+ext4 uses to make these decisions.
 </para>
 
 <para>
 Another wriggle to watch out for is your on-disk block allocation strategy.
-why? Because, if you undo a delete, you need to ensure you haven't reused any
-of the freed blocks in a later transaction. One simple way of doing this
-is make sure any blocks you allocate only have checkpointed transactions
-listed against them. Ext3 does this in ext3_test_allocatable().
+Why? Because, if you do a delete, you need to ensure you haven't reused any
+of the freed blocks until the transaction freeing these blocks commits. If you
+reused these blocks and crash happens, there is no way to restore the contents
+of the reallocated blocks at the end of the last fully committed transaction.
+
+One simple way of doing this is to mark blocks as free in internal in-memory
+block allocation structures only after the transaction freeing them commits.
+Ext4 uses journal commit callback for this purpose.
+</para>
+
+<para>
+With journal commit callbacks you can ask the journalling layer to call a
+callback function when the transaction is finally committed to disk, so that
+you can do some of your own management. You ask the journalling layer for
+calling the callback by simply setting journal->j_commit_callback function
+pointer and that function is called after each transaction commit. You can also
+use transaction->t_private_list for attaching entries to a transaction that
+need processing when the transaction commits.
 </para>
 
 <para>
-Lock is also providing through journal_{un,}lock_updates(),
-ext3 uses this when it wants a window with a clean and stable fs for a moment.
-eg.
+JBD2 also provides a way to block all transaction updates via
+jbd2_journal_{un,}lock_updates(). Ext4 uses this when it wants a window with a
+clean and stable fs for a moment.  E.g.
 </para>
 
 <programlisting>
 
-	journal_lock_updates() //stop new stuff happening..
-	journal_flush()        // checkpoint everything.
+	jbd2_journal_lock_updates() //stop new stuff happening..
+	jbd2_journal_flush()        // checkpoint everything.
 	..do stuff on stable fs
-	journal_unlock_updates() // carry on with filesystem use.
+	jbd2_journal_unlock_updates() // carry on with filesystem use.
 </programlisting>
 
 <para>
@@ -286,29 +295,6 @@ if you allow unprivileged userspace to trigger codepaths containing these
 calls.
 </para>
 
-<para>
-A new feature of jbd since 2.5.25 is commit callbacks with the new
-journal_callback_set() function you can now ask the journalling layer
-to call you back when the transaction is finally committed to disk, so that
-you can do some of your own management. The key to this is the journal_callback
-struct, this maintains the internal callback information but you can
-extend it like this:-
-</para>
-<programlisting>
-	struct  myfs_callback_s {
-		//Data structure element required by jbd..
-		struct journal_callback for_jbd;
-		// Stuff for myfs allocated together.
-		myfs_inode*    i_commited;
-
-	}
-</programlisting>
-
-<para>
-this would be useful if you needed to know when data was committed to a
-particular inode.
-</para>
-
     </sect2>
 
     <sect2 id="jbd_summary">
@@ -319,36 +305,6 @@ being each mount, each modification (transaction) and each changed buffer
 to tell the journalling layer about them.
 </para>
 
-<para>
-Here is a some pseudo code to give you an idea of how it works, as
-an example.
-</para>
-
-<programlisting>
-  journal_t* my_jnrl = journal_create();
-  journal_init_{dev,inode}(jnrl,...)
-  if (clean) journal_wipe();
-  journal_load();
-
-   foreach(transaction) { /*transactions must be
-                            completed before
-                            a syscall returns to
-                            userspace*/
-
-          handle_t * xct=journal_start(my_jnrl);
-          foreach(bh) {
-                journal_get_{create,write,undo}_access(xact,bh);
-                if ( myfs_modify(bh) ) { /* returns true
-                                        if makes changes */
-                           journal_dirty_{meta,}data(xact,bh);
-                } else {
-                           journal_forget(bh);
-                }
-          }
-          journal_stop(xct);
-   }
-   journal_destroy(my_jrnl);
-</programlisting>
     </sect2>
 
     </sect1>
@@ -357,13 +313,13 @@ an example.
      <title>Data Types</title>
      <para>
 	The journalling layer uses typedefs to 'hide' the concrete definitions
-	of the structures used. As a client of the JBD layer you can
+	of the structures used. As a client of the JBD2 layer you can
 	just rely on the using the pointer as a magic cookie  of some sort.
 
 	Obviously the hiding is not enforced as this is 'C'.
      </para>
 	<sect2 id="structures"><title>Structures</title>
-!Iinclude/linux/jbd.h
+!Iinclude/linux/jbd2.h
 	</sect2>
     </sect1>
 
@@ -375,11 +331,11 @@ an example.
 	manage transactions
      </para>
 	<sect2 id="journal_level"><title>Journal Level</title>
-!Efs/jbd/journal.c
-!Ifs/jbd/recovery.c
+!Efs/jbd2/journal.c
+!Ifs/jbd2/recovery.c
 	</sect2>
 	<sect2 id="transaction_level"><title>Transasction Level</title>
-!Efs/jbd/transaction.c
+!Efs/jbd2/transaction.c
 	</sect2>
     </sect1>
     <sect1 id="see_also">
-- 
2.1.4
