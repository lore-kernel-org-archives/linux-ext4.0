From: Chris Mason <chris.mason@oracle.com>
Subject: Fun with fdatasync()
Date: Mon, 12 Oct 2009 10:00:49 -0400
Message-ID: <20091012140049.GO2632@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, jbacik@redhat.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932207AbZJLOB4@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hello everyone,

Josef has been doing some benchmarking around rpm performance on the
filesystem and noticed that ext3 was going really fast on the
fdatasyncs.

It seems pretty surprising to me that rpm -Uvh should do fdatasync
without forcing fsyncs.  The files get overwritten, and any time we mark
an inode dirty I_DIRTY_DATASYNC is getting set.

Handling of I_DIRTY_DATASYNC seems to work like this:

mark_inode_dirty() will set I_DIRTY_DATASYNC

ext3_sync_file will force a full commit on I_DIRTY_DATASYNC

This part makes good sense.  If the inode has changed, we're supposed to
do a full commit.

writeback_single_inode is where things seem to go wrong:

        /* Set I_SYNC, reset I_DIRTY */
        dirty = inode->i_state & I_DIRTY;
        inode->i_state |= I_SYNC;
        inode->i_state &= ~I_DIRTY;

Whoops, we just lost I_DIRTY_DATASYNC.  So, if pdflush comes in and does some
writeback before we fdatasync, we'll skip the full commit because
I_DIRTY_DATASYNC is gone.

The solution to me seems to be that we need to keep I_DIRTY_DATASYNC
until the FS does an fsync/O_SYNC operation, and make the FS
responsible for clearing it.

This does risk extra full fsyncs if the FS does a transaction commit on
its own, but the FS should be responsible for keeping track of which
transaction last changed a given file and doing a shortcut in the fsync
code if the file is already on safely on disk.

Am I missing something?  I don't see how fdatasync is safe in our
current usage.

-chris
