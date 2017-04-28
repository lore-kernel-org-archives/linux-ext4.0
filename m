From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] jbd2: Fix dbench4 performance regression for 'nobarrier'
 mounts
Date: Fri, 28 Apr 2017 08:03:24 -0700
Message-ID: <20170428150324.GA20122@infradead.org>
References: <20170428095934.11583-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170428095934.11583-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 28, 2017 at 11:59:34AM +0200, Jan Kara wrote:
> Fix the problem by making sure journal superblock writes are always
> treated as synchronous since they generally block progress of the
> journalling machinery and thus the whole filesystem.

The callchains leading down to jbd2_write_superblock looks a little
suspicious to me.  It seems like jbd2_journal_commit_transaction
will actually call without FUA in the JBD2_FLUSHED case. Is that
really intentional, and if yes should it be documented?

Except for that it would seem more useful to move to a "bool preflush"
argument passed down.

But I guess we'll need a quick fix first, for that:

Reviewed-by: Christoph Hellwig <hch@lst.de>
