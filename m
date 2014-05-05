From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] mke2fs: print a message when creating a regular file
Date: Mon, 5 May 2014 10:49:38 -0400
Message-ID: <20140505144938.GH22287@thunk.org>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051532280.2223@localhost.localdomain>
 <20140505135239.GB22287@thunk.org>
 <5367A445.9070209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49911 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbaEEOtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 10:49:45 -0400
Content-Disposition: inline
In-Reply-To: <5367A445.9070209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 09:46:29AM -0500, Eric Sandeen wrote:
> > Even if there is some case in the future where dev_size could be left
> > unset, it will be initialized to zero, at which point we will fail
> > safe by skipping the mke2fs_discard_device() call.
> 
> I kind of lost the thread here; if it is impossible to be unset, why
> add the check?
> 
> And if (!dev_size) what would happen on this path?  I guess I need to get
> all the pending patches applied to see what's changed in this area.

It's mostly cosmetic, to be honest.  It avoids this confusing line:

5% ./misc/mke2fs -t ext4 /tmp/foo.img 16M
mke2fs 1.42.9 (4-Feb-2014)
Creating regular file /tmp/foo.img
Discarding device: done         <========== this nonsense line
Creating filesystem with 16384 1k blocks and 4096 inodes
Filesystem UUID: 515a4e52-79f1-4317-ad61-a87c492c1371
Superblock backups stored on blocks: 
	   8193
   ...

				- Ted

