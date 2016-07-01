From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Fri, 1 Jul 2016 17:26:34 -0400
Message-ID: <20160701212634.GA14277@thunk.org>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
 <20160701165339.GB6075@thunk.org>
 <20160701174041.GA30040@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160701174041.GA30040@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 01, 2016 at 07:40:41PM +0200, Jan Kara wrote:
> 
> So we are waiting for transaction commit to finish with unsubmitted pages
> that already have PageWriteback set (and also potentially other pages that
> are locked and we didn't prepare them for writing because the block mapping
> we got was too short). Now JBD2 goes on trying to do the transaction
> commit:

Ah, I see, so this is only an issue in those cases where the handle is
synchronous.  Is this the only case where there is a concern?  (e.g.,
could we test handle->h_sync and stop the handle early if h_sync
is not set?)  This would put the uninit->init conversion into
potentially a separate transaction, but that should be OK.

The reason why I'm pushing so hard here is that long running handles
is a major contributor to ext4 haveing poor CPU scalability numbers,
since we can end up having lots of threads waiting on the last
transaction to complete.  So keeping transactions small and fast is a
big deal.

							- Ted
