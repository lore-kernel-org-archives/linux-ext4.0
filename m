Return-Path: <SRS0=+plc=NX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44336 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731541AbeKLQbp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Nov 2018 11:31:45 -0500
Date: Mon, 12 Nov 2018 01:39:47 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Kevin Liu <kevin@potatofrom.space>
Cc: linux-ext4@vger.kernel.org, bfields@fieldses.org
Subject: Re: ext4-nfsd interaction causes sporadic hang on
 rwsem_down_write_failed
Message-ID: <20181112063947.GB7377@thunk.org>
References: <56454f6d-bbf8-fcd5-d389-50d5c3653ba6@potatofrom.space>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56454f6d-bbf8-fcd5-d389-50d5c3653ba6@potatofrom.space>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 12, 2018 at 04:38:34AM +0000, Kevin Liu wrote:
> Hi,
> 
> I recently submitted an NFS bug
> (https://bugzilla.kernel.org/show_bug.cgi?id=201655) where nfsd randomly
> locks up on rwsem_down_write_failed:

> So, starting with ext4, I was wondering if you had an idea of what the
> cause might be or where the fault truly lies.

Sorry, this isn't something I've seen before.  And it's not at all
obvious from the information in Bugzilla what's causing the deadlock.

The down_read() up appears to be in mm/memory.c, in
__access_remote_vm() getting called from proc_pid_cmdline_read().
access_Remote_vm is apparently trying to get a shared lock on
&mm->mmap_sem.  How this would get involved with the inode_lock() is
not immediately obvious.

Things I would suggest.

1) Try running your kernel console log throughn
./scripts/decode_stacktrace.sh so we can be sure we've correctly
assessed where the kernel is grabbing which lock.  Enabling
CONFIG_DEBUG_INFO and CONFIG_DEBUG_INFO_REDUCED will be helpful.

2) Try turning on CONFIG_LOCKDEP and see if this reports some
potential deadlock.

3) Try using sysrq-d to find all held locks (running the resulting
kernel console output through decode_stacktrace.sh will also eb
helpful).

Cheers,

					- Ted
