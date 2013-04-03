From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: per inode fsync optimization question
Date: Wed, 03 Apr 2013 19:09:33 +0400
Message-ID: <87zjxfps5u.fsf@openvz.org>
References: <8738v7r8xx.fsf@openvz.org> <20130403145055.GD14667@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:51497 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761890Ab3DCPJi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 11:09:38 -0400
Received: by mail-la0-f44.google.com with SMTP id eb20so1552625lab.17
        for <linux-ext4@vger.kernel.org>; Wed, 03 Apr 2013 08:09:36 -0700 (PDT)
In-Reply-To: <20130403145055.GD14667@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 3 Apr 2013 16:50:55 +0200, Jan Kara <jack@suse.cz> wrote:
> On Wed 03-04-13 18:21:46, Dmitry Monakhov wrote:
> > inode store i_sync_tid and i_datasync_tid  in order to optimize journal
> > flushes and wait for commits only when necessary, but
> > fields are declared as tid_t(not atomic_t as it done in ext3) so we
> > have not synchronization between readers and writers, so gcc and cpu
> > is allowed to perform prefetch, cache and other stuff.
> > Looks like a bug, right?
>   Reads and writes to atomic_t aren't guaranteed to be any kind of a
> barrier (if fact they are compiled as simple stores and loads on x86). Only
> arithmetic operations on atomic types are special. So using tid_t is just
> fine.
Ok but what about prefetching?
Compiler is allowed to prefetch on early stage ?
should we use ACCESS_ONCE() or wmb() and rmb() here?


> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
