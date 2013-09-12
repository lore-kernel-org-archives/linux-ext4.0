From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Java Stop-the-World GC stall induced by FS flush or many large
 file deletions
Date: Thu, 12 Sep 2013 15:02:51 -0400
Message-ID: <20130912190251.GB28067@thunk.org>
References: <CALQm4jhE8aRjOsK2HpSuqNCzNqZm5RU9QOJi0q0SwgR=1JKZsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Cuong Tran <cuonghuutran@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59155 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab3ILTCx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Sep 2013 15:02:53 -0400
Content-Disposition: inline
In-Reply-To: <CALQm4jhE8aRjOsK2HpSuqNCzNqZm5RU9QOJi0q0SwgR=1JKZsQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Are you absolutely certain your JVM attempting to write to any files
in its GC thread?  Say, to do some kind of logging?  It might be worth
stracing the JVM and correlating the GC stall with any syscalls that
might have been issued from the JVM GC thread.

Especially in the case of the FS Flush, the writeback thread isn't CPU
bound.  It will wait for the writeback to complete, but while it's
waiting, other processes or threads will be allowed to run on the CPU.

Now, if the GC thread tries to do some kind of fs operation which
requires writing to the file system, and the file sytstem is trying to
start a jbd transaction commit, file system operations can block until
all of the jbd handles associated with the previous commit can
complete.  If you are storage devices are slow, or you are using a
block cgroup to control how much I/O bandwidth a particular cgroup
could use, this can end up causing a priority inversion where a low
priority cgroup takes a while to complete, this can stall the jbd
commit completion, and this can cause new ext4 operations can stall
waiting to start a new jbd handle.

So you could have a stall happening, if it's taking a long time for
commits to complete, but it might be completely unrelated to a GC
stall.

If you enable the jbd2_run_stats tracepoint, you can get some
interesting numbers about how long the various phases of the jbd2
commit are taking.

              				- Ted
