From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Fri, 1 Jul 2016 12:53:39 -0400
Message-ID: <20160701165339.GB6075@thunk.org>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160701090950.GB22922@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 01, 2016 at 11:09:50AM +0200, Jan Kara wrote:
> But it is not safe - the bio contains pages, those pages have PageWriteback
> set and if the inode is part of the running transaction,
> ext4_journal_stop() will wait for transaction commit which will wait for
> all outstanding writeback on the inode, which will deadlock on those pages
> which are part of our unsubmitted bio. So the ordering really has to be the
> way it is...

So to be clear. the issue is that PageWriteback won't get cleared
until we potentially do a uninit->init conversion, and this is what
requires taking a transaction handle leading to the other half of the
deadlock?

... and it's probably not safe to clear the PageWriteback early in the
bio completion callback function, isn't it.  Hmm....

						- Ted
