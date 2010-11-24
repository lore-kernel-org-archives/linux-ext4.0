From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Wed, 24 Nov 2010 14:47:40 -0800
Message-ID: <20101124144740.bffb2716.akpm@linux-foundation.org>
References: <20101123100239.GA4232@amd>
	<1290515274-sup-3895@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@kernel.dk>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1290515274-sup-3895@think>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 23 Nov 2010 07:34:07 -0500
Chris Mason <chris.mason@oracle.com> wrote:

> For btrfs there's only one bdi per SB, but for most everyone else a disk
> with a bunch of partitions is going to have multiple filesystems on the
> same bdi.

um, please explain why that wasn't idiotic?  The BDI is a
representation of a backing device and it's *supposed* to provide
visibility into what's happening against other partitions on the same
device.  Creating a BDI per SB (it didn't even occur to me to think
that a filesystem was even able to do this) breaks that.


