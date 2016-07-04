From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Mon, 4 Jul 2016 11:20:43 -0400
Message-ID: <20160704152043.GA15193@thunk.org>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
 <20160701165339.GB6075@thunk.org>
 <20160701174041.GA30040@quack2.suse.cz>
 <20160701212634.GA14277@thunk.org>
 <20160704140012.GG5200@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160704140012.GG5200@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 04, 2016 at 04:00:12PM +0200, Jan Kara wrote:
> OK, but we do all the block mappings, page locking etc. while the handle is
> started so it is not exactly a really short lived handle. The patch adds
> there a submission of a bio (we have the IO plugged so it will just add the
> bio to the list of submitted bios), unlock locked pages, drop refcount to
> ioend (unless IO is already completed, only refcount update is done, if IO
> is completed we defer any real work to workqueue anyway). So although we
> add some work which is done while the handle is still running, it is not
> that much.

Good point that the block device is plugged.  Ultimately I suspect the
way to fix the scalability problem will be move to dioread nolock as
the default, and use separate transaction to map the blocks using the
uninitialized flags, and then do a separate transaction to convert
them afterwards.

						- Ted
