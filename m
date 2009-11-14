From: Theodore Tso <tytso@mit.edu>
Subject: Re: Dirent blocks leaking into data file blocks
Date: Sat, 14 Nov 2009 18:29:12 -0500
Message-ID: <20091114232912.GF4221@mit.edu>
References: <6601abe90911131546v43838123g3bc312d46a97e199@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48687 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZKNX3I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Nov 2009 18:29:08 -0500
Content-Disposition: inline
In-Reply-To: <6601abe90911131546v43838123g3bc312d46a97e199@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 13, 2009 at 03:46:09PM -0800, Curt Wohlgemuth wrote:
> So when a directory is removed with "rm -rf foo" , as the files are deleted,
> the directory block(s) are marked dirty.  But when the directory blocks
> themselves are freed up, bforget() isn't called for their bufferheads, and
> so they remain dirty in the page cache, and can be written down later, after
> their blocks have been reused.

Well, it should be happening as part of the call to ext4_forget().  It
looks like it's happening on the code paths that release the blocks.
This is critically important if journalling is enabled, since we have
to call jbd2_journal_revoke() on directory blocks before they can be
reused as data blocks.  Hmm, if the buffer was part of a transaction,
we don't call __bforget() on it in jbd2_journal_forget().  So I can
see how you might be seeing a problem with journalling enabled, but
I'm puzzled why you were also seeing a problem without journalling.

So to help debug what is going on, I tried adding the a new tracepoint
to ext4_forget().  I've attached it to the end of this message.  Using
it, I can confirm that ext4_forget() is getting called for
directories.  I do see a problem though that we're not checking to see
if the inode is a directory; in that case, we need to treat it as if
it were metadata, and call ext4_journal_revoke() instead of
ext4_journal_forget().  Otherwise we could have the problem that after
a crash, on a journal replay, we might end up replaying the directory
block after it has been reallocated and used as a data block.
(Hmm.... I think this might be a problem for ext3 as well.)

I am very puzzled why you are seeing a problem in no journal mode,
though.  It looks like the right thing should be happening.  Is the
8MB data file is getting written via direct I/O or buffered I/O?

    	      	 	 	     	    	- Ted


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 554c679..13de1dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -89,6 +89,7 @@ int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 
 	might_sleep();
 
+	trace_ext4_forget(inode, is_metadata, blocknr);
 	BUFFER_TRACE(bh, "enter");
 
 	jbd_debug(4, "forgetting bh %p: is_metadata = %d, mode %o, "
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index d09550b..b390e1f 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -907,6 +907,32 @@ TRACE_EVENT(ext4_mballoc_free,
 		  __entry->result_len, __entry->result_logical)
 );
 
+TRACE_EVENT(ext4_forget,
+	TP_PROTO(struct inode *inode, int is_metadata, __u64 block),
+
+	TP_ARGS(inode, is_metadata, block),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	umode_t, mode			)
+		__field(	int,	is_metadata		)
+		__field(	__u64,	block			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->mode	= inode->i_mode;
+		__entry->is_metadata = is_metadata;
+		__entry->block	= block;
+	),
+
+	TP_printk("dev %s ino %lu mode %d is_metadata %d block %llu",
+		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
+		  __entry->mode, __entry->is_metadata, __entry->block)
+);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */
