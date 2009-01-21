From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing
	device caches should be flushed
Date: Wed, 21 Jan 2009 14:03:22 -0800
Message-ID: <20090121220322.GM2392@mail.oracle.com>
References: <20090120160527.GA17067@duck.suse.cz> <20090120231647.GC2392@mail.oracle.com> <20090121125537.GB3186@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:59641 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZAUWEo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jan 2009 17:04:44 -0500
Content-Disposition: inline
In-Reply-To: <20090121125537.GB3186@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 21, 2009 at 01:55:37PM +0100, Jan Kara wrote:
> On Tue 20-01-09 15:16:48, Joel Becker wrote:
> > On Tue, Jan 20, 2009 at 05:05:27PM +0100, Jan Kara wrote:
> > >   we noted in our testing that ext2 (and it seems some other filesystems as
> > > well) don't flush disk's write caches on cases like fsync() or changing
> > > DIRSYNC directory. This is my attempt to solve the problem in a generic way
> > > by calling a filesystem callback from VFS at appropriate place as Andrew
> > > suggested. For ext2 what I did is enough (it just then fills in
> > > block_flush_device() as .flush_device callback) and I think it could be
> > > fine for other filesystems as well.
> > 
> > 	The only question I have is why this would be optional.  It
> > would seem that this would be the preferred default behavior for all
> > block filesystems.  We have the backing_dev_info and a way to override
> > the default if a filesystem needs something special.
>   The reason why I've decided for NOP to be the default is that filesystems
> doing proper journalling with barriers should not need this (as the barrier
> in the transaction commit already does the job for them).  So these would
> have to override the operation to NOP which seems a bit silly. Also virtual
> filesystems without backing device would have to override this to NOP.

	You make a fair point about journaling filesystems - except, of
course, that they don't really use barriers; mount defaults or
device-mapper often preclude them.  So people with 'incorrect' barrier
configurations get no fsync() safety.
	Regarding "filesystems without a backing device", that's why I
said "we have backing_dev_info".  We can tell what the backing device
is; we should be able to determine that no flush is needed without
modifying those filesystems.

>   Finally, I prefer maintainers of the filesystems themselves to decide
> whether their filesystem needs flushing and thus knowingly impose this
> performance penalty on them...

	I understand what you're thinking here, but that way defaults to
an unsafe fsync().  Thus you're causing broken behavior in the hopes
that maintainers pay enough attention to fix the behavior.

Joel

-- 

Life's Little Instruction Book #274

	"Leave everything a little better than you found it."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
