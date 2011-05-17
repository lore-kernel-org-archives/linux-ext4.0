From: Jan Kara <jack@suse.cz>
Subject: Re: JBD commmit : Get list of all 'to be written' buffers in
 advance
Date: Tue, 17 May 2011 20:09:30 +0200
Message-ID: <20110517180930.GC30519@quack.suse.cz>
References: <4DCBED1D.2010109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48984 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab1EQSJv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 14:09:51 -0400
Content-Disposition: inline
In-Reply-To: <4DCBED1D.2010109@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 12-05-11 19:52:21, Niraj Kulkarni wrote:
>          I am trying to implement a concept called Transactional
> Flash (http://www.usenix.org/event/osdi08/tech/full_papers/prabhakaran/prabhakaran_html/)
> 
>          in which all writes are flushed to disk (in this case
> Flash) as a circular linked list of pages. No journaling mechanisms
> are used.
>           For that I am trying to get list of all buffers to be
> written (metadata or data) before actually writing them. I thought
> of 2 approaches :
> 
> 1. Get conservative list of all buffers before flushing any of them
> (before commit phase 2) in journal_commit_transaction function.
>      Problem : Metadata writes use temporary buffers which are
> allocated just before write.
  Well, if I understand the transactional flash concept right, what you
should do is to replace code committing metadata to the journal by
something which writes metadata directly to final location. That should be
relatively easy modification of loops in journal_commit_transaction(). BTW,
you might want to use ext4/jbd2 instead of ext3/jbd as a base for your
experiments since ext3 is basically deprecated.

> 2. Instead of submitting buffers straightaway, collect all of them (
> data + metadata ) and flush them in end.
>      Problem :  i.   Possibility of blocking after data buffers are
> collected but before metadata buffer collection.
>                            Since data buffers are locked, this may
> lead to deadlock. (I am not sure if it is spinlock)
> 
>                       ii.   Not able to differentiate between
> metadata buffers and Descriptor buffers.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
