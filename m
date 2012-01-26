From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] ext4: fix race between unwritten extent conversion and truncate
Date: Thu, 26 Jan 2012 16:17:08 -0500
Message-ID: <x4962fyyxij.fsf@segfault.boston.devel.redhat.com>
References: <x49aa5ayycg.fsf@segfault.boston.devel.redhat.com>
	<20120126211526.GA28368@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab2AZVRf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jan 2012 16:17:35 -0500
In-Reply-To: <20120126211526.GA28368@quack.suse.cz> (Jan Kara's message of
	"Thu, 26 Jan 2012 22:15:26 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Thu 26-01-12 15:59:11, Jeff Moyer wrote:
>> Hi,
>> 
>> The following comment in ext4_end_io_dio caught my attention:
>> 
>> 	/* XXX: probably should move into the real I/O completion handler */
>>         inode_dio_done(inode);
>> 
>> The truncate code takes i_mutex, then calls inode_dio_wait.  Because the
>> ext4 code path above will end up dropping the mutex before it is
>> reacquired by the worker thread that does the extent conversion, it
>> seems to me that the truncate can happen out of order.  Jan Kara
>> mentioned that this might result in extra journal I/O, which isn't nice,
>   Funny misunderstanding ;) I meant we will complain to system log with error
> messages / WARN_ON.

Heh.  Ted, let me know if I need to repost to fix that up...

Cheers,
Jeff
