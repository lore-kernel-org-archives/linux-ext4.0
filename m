From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing
	device caches should be flushed
Date: Tue, 20 Jan 2009 15:16:48 -0800
Message-ID: <20090120231647.GC2392@mail.oracle.com>
References: <20090120160527.GA17067@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090120160527.GA17067@duck.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 20, 2009 at 05:05:27PM +0100, Jan Kara wrote:
>   we noted in our testing that ext2 (and it seems some other filesystems as
> well) don't flush disk's write caches on cases like fsync() or changing
> DIRSYNC directory. This is my attempt to solve the problem in a generic way
> by calling a filesystem callback from VFS at appropriate place as Andrew
> suggested. For ext2 what I did is enough (it just then fills in
> block_flush_device() as .flush_device callback) and I think it could be
> fine for other filesystems as well.

	The only question I have is why this would be optional.  It
would seem that this would be the preferred default behavior for all
block filesystems.  We have the backing_dev_info and a way to override
the default if a filesystem needs something special.

Joel

-- 

"A narcissist is someone better looking than you are."  
         - Gore Vidal

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
