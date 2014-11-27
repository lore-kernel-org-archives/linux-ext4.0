From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
 write_time()
Date: Thu, 27 Nov 2014 07:25:04 -0800
Message-ID: <20141127152504.GA15839@infradead.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-2-git-send-email-tytso@mit.edu>
 <20141126192328.GA20436@infradead.org>
 <20141127123429.GD30152@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141127123429.GD30152@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 27, 2014 at 01:34:29PM +0100, Jan Kara wrote:
>   But Ted changed XFS to copy timestamps to on-disk structure from the
> in-memory inode fields after VFS updated the timestamps. So the stamps
> should be coherent AFAICT, shouldn't they?

Not coherent enough.  We need the XFS ilock to synchronize reading from
and writing to the time stamps.  update_time() only has i_mutex, which
we can't take for the transaction commit path.
