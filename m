From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 3/7] ext4: shutdown should not prevent get_write_access
Date: Thu, 22 Mar 2018 11:38:12 -0400
Message-ID: <20180322153811.GG2852@thunk.org>
References: <20180220023038.19883-1-tytso@mit.edu>
 <20180220023038.19883-4-tytso@mit.edu>
 <20180307094201.ihki3mh7lnib4ta4@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180307094201.ihki3mh7lnib4ta4@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 07, 2018 at 10:42:01AM +0100, Jan Kara wrote:
> On Mon 19-02-18 21:30:34, Theodore Ts'o wrote:
> > The ext4 forced shutdown flag needs to prevent new handles from being
> > started, but it needs to allow existing handles to complete.  So the
> > forced shutdown flag should not force ext4_journal_get_write_access to
> > fail.
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Cc: stable@vger.kernel.org
> 
> OK, if you want the semantics of ext4 shutdown to be that running
> handles should be allowed to complete, I see where you are going with this
> patch. However there are more problems with this semantics than just
> __ext4_journal_get_write_access(). Just for example
> ext4_reserve_inode_write() will bail in case the fs got shutdown and thus
> inode changes won't be properly added to the running handle. Also places
> that rely on nested transactions being possible will not work because
> ext4_journal_start_sb() will refuse to get refcount of a running handle
> (ext4_journal_check_start() fails) in case fs got shutdown. And I may have
> missed other cases.

We have three cases in ext4_shutdown:

EXT4_GOING_FLAGS_DEFUALT:
    Freezes the block device, sets the EXT4_FLAGS_SHUTDOWN flag, and then
    unfreezes the block device:

EXT4_GOING_FLAGS_LOGFLUSH:
    Sets the EXT4_FLAGS_SHUTDOWN flag, forces a commit, and then aborts
    the journal.

EXT4_GOING_FLAGS_NOLOGFLUSH
    Sets the EXT4_FLAGS_SHUTDOWN flag, aborts the journal.

> The above problems are a reason why I though the semantics of ext4 shutdown
> was terminate the fs *now* - effectively a software equivalent of power
> off. That is much easier to implement since we just have to make sure no
> running handle makes it to the journal... Since I've said Google is using
> ext4 shutdown - is there any reason why you need the "running handles are
> allowed to finish" semantics? After all it seems it's just a race whether
> some handle makes it before the cut off or not...

Good points.  I'll have to look at what happens if we just drop the
EXT4_FLAGS_SHUTDOWN flag altogether.

							- Ted
