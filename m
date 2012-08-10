From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add max_dir_size_kb mount option
Date: Fri, 10 Aug 2012 17:59:59 -0400
Message-ID: <20120810215959.GB1137@thunk.org>
References: <1344626638-31548-1-git-send-email-tytso@mit.edu>
 <50256322.9040409@redhat.com>
 <20120810195907.GA557@thunk.org>
 <50256C39.4030502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44060 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758713Ab2HJWAB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Aug 2012 18:00:01 -0400
Content-Disposition: inline
In-Reply-To: <50256C39.4030502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 10, 2012 at 03:16:57PM -0500, Eric Sandeen wrote:
> 
> Oh, I thought this was papering over a scaling problem in ext4.  The intent
> is to protect userspace from arbitrarily large readdir results?

The problem that arose was that the directory had grown to 176mb, and
in a tight memory cgroup (say, 512mb, or some such), this could cause
significant memory thrashing, or the actual OOM killing of the task in
said tight memory cgroup when it tried to read the entire directory
via readdir().

> If that's the case, this should probably be proposed as a VFS level
> option, and see how it's received there...

It's not really a VFS level thing, since the goal is to stop the
directory size itself from growing beyond a size limit (say, 1mb).

	       	      	   	   	    - Ted
