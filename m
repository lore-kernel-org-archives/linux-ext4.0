From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Mon, 29 Nov 2010 19:50:46 -0500
Message-ID: <1291075500-sup-6320@think>
References: <20101123100239.GA4232@amd> <1290515274-sup-3895@think> <20101124144740.bffb2716.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Nick Piggin <npiggin@kernel.dk>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20101124144740.bffb2716.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Excerpts from Andrew Morton's message of 2010-11-24 17:47:40 -0500:
> On Tue, 23 Nov 2010 07:34:07 -0500
> Chris Mason <chris.mason@oracle.com> wrote:
> 
> > For btrfs there's only one bdi per SB, but for most everyone else a disk
> > with a bunch of partitions is going to have multiple filesystems on the
> > same bdi.
> 
> um, please explain why that wasn't idiotic?  The BDI is a
> representation of a backing device and it's *supposed* to provide
> visibility into what's happening against other partitions on the same
> device.  Creating a BDI per SB (it didn't even occur to me to think
> that a filesystem was even able to do this) breaks that.
> 

We don't really have visibility into the other partitions, we all just
pretend they aren't there (this patch being the most recent example).
Yes, it does help prevent N flushers seeking around on the drive but it
does cause problems too.

How is the btrfs one-bdi-per-super different from device mapper's one
bdi per logical volume?  We're all idiots together I suppose.

As for having multiple bdis per FS, that was always a long term goal of
mine when Jens was setting up the new flushers.  I didn't want to
confuse the initial implementation with it though.

-chris
