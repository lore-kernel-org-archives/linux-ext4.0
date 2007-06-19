From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: kjournald hang on ext3 to ext3 copy
Date: Mon, 18 Jun 2007 23:14:02 -0600
Message-ID: <20070619051402.GO5181@schatzie.adilger.int>
References: <4673E2F1.2090704@sbcglobal.net> <20070618062027.GB5181@schatzie.adilger.int> <4677531E.1030108@sbcglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext3-users@redhat.com, linux-ext4@vger.kernel.org
To: John Marconi <jamarconi@sbcglobal.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:55781 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXFSFOF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 01:14:05 -0400
Content-Disposition: inline
In-Reply-To: <4677531E.1030108@sbcglobal.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 18, 2007  22:53 -0500, John Marconi wrote:
> Andreas Dilger wrote:
> >Two tips for debugging this kind of issue:
> >- you need to have detailed stack traces (e.g. sysrq-t) of all the
> >  interesting processes
> >
> >- if a process is stuck inside a large function (e.g. 8379 in example)
> >  you need to provide the exact line number.  this can be found by 
> >  compiling
> >  the kernel with CONFIG_DEBUG_INFO (-g flag to gcc) and then doing
> >  "gdb vmlinux" and "p *(journal_commit_transaction+{offset})", where the
> >  byte offset is printed in the sysrq-t output, and then include the code
> >  surrounding that line from the source file
> >
> >- a process stuck in "start_this_handle()" is often just an innocent
> >  bystander.  It is waiting for the currently committing transaction to
> >  complete before it can start a new filesystem-modifying operation 
> >  (handle).
> >  That said, the journal handle acts like a lock and has been the cause of
> >  many deadlock problems (e.g. process 1 holds lock, waits for handle;
> >  process 2 holds transaction open waiting for lock).  pdflush might be one
> >  of the "process 1" kind of tasks, and some other process is holding the
> >  transaction open preventing it from completing.
> 
> I am not able to update the entire kernel to a new version for a variety 
> of reasons, however I can update certain parts in my system (such as the 
> filesystem).  I did a diff of the 2.6.16 kernel against my kernel, and 
> the changes to jbd were minimal.  I plan on looking at the latest 
> versions of the kernel to determine if anything has changed since 2.6.16.

The problem may also be in the ext3 layer and not jbd.

> I took a look at the place that kjournald was stuck - it is in the 
> journal_commit_transaction "while (comiit_transaction->t_updates)" loop 
> and it is trying to "spin_lock(&journal->j_state_lock).  When I look at 
> pdflush, it is also trying to take the journal->j_state_lock.  Do you 
> have any tips on finding out which process might own journal->j_state_lock?

You can enable CONFIG_DEBUG_SPINLOCK in newer kernels and it appears the
spinlock will set the "owner" field to the task struct.  You still need
to get access to this via e.g. "crash" or lkcd or something.

Hmm, it seems this is only set for ppc and s390???  That is how I would
debug this in any case.  The other way (I've done this too many times
in the past) is to look through all of the stack traces and figure out
which ones are in a filesystem context, then check if any of them are
blocked on locks while holding transactions open.  Needs a detailed
understanding of kernel callpaths.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
