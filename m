From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Thu, 5 May 2011 13:18:06 +0200
Message-ID: <20110505111806.GA5323@quack.suse.cz>
References: <4DA84A7B.3040403@jp.fujitsu.com>
 <20110415171310.GB5432@quack.suse.cz>
 <4DABFEBD.7030102@jp.fujitsu.com>
 <4DBFE09E.5070805@canonical.com>
 <20110503151948.GB6009@quack.suse.cz>
 <4DC14201.6090009@canonical.com>
 <20110504191912.GB6968@quack.suse.cz>
 <4DC1C67B.3030801@canonical.com>
 <20110504224824.GO6968@quack.suse.cz>
 <4DC23E65.7080507@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab1EELSJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 07:18:09 -0400
Content-Disposition: inline
In-Reply-To: <4DC23E65.7080507@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 05-05-11 09:06:29, Surbhi Palande wrote:
> On 05/05/2011 01:48 AM, Jan Kara wrote:
> >On Thu 05-05-11 00:34:51, Surbhi Palande wrote:
> >>On 05/04/2011 10:19 PM, Jan Kara wrote:
> >>>On Wed 04-05-11 15:09:37, Surbhi Palande wrote:
> >>>>On 05/03/2011 06:19 PM, Jan Kara wrote:
> >>>>>On Tue 03-05-11 14:01:50, Surbhi Palande wrote:
> >>>>>>What happens in the case as follows:
> >>>>>>
> >>>>>>Task 1: Mmapped writes
> >>>>>>t1)ext4_page_mkwrite()
> >>>>>>   t2) ext4_write_begin() (FS is thawed so we proceed)
> >>>>>>   t3) ext4_write_end() (journal is stopped now)
> >>>>>>-----Pre-empted-----
> >>>>>>
> >>>>>>
> >>>>>>Task 2: Freeze Task
> >>>>>>t4) freezes the super block...
> >>>>>>...(continues)....
> >>>>>>tn) the page cache is clean and the F.S is frozen. Freeze has
> >>>>>>completed execution.
> >>>>>>
> >>>>>>Task 1: Mmapped writes
> >>>>>>tn+1) ext4_page_mkwrite() returns 0.
> >>>>>>tn+2) __do_fault() gets control, code gets executed.
> >>>>>>tn+3) _do_fault() marks the page dirty if the intent is to write to
> >>>>>>a file based page which faulted.
> >>>>>>
> >>>>>>So you end up dirtying the page cache when the F.S is frozen? No?
> >>>>>   You are right ext4_page_mkrite() as currently implemented has problems.
> >>>>>You have to return the page locked (and check for frozen fs with page lock
> >>>>>held) to avoid races.
> >>>>>
> >>>>>If you check for frozen fs with page lock held, you are guaranteed that
> >>>>>freezing code must wait for the page to get unlocked before proceeding. And
> >>>>>before the page is unlocked, it is marked dirty by the pagefault code which
> >>>>>makes freezing code write the page and writeprotect it again. So everything
> >>>>>will be safe.
> >>>>For the locked page to be a part of the freeze initiated sync,
> >>>>should its owner inode not be dirtied? The page fault handler
> >>>>dirties the page, but who ensures that the inode is dirtied at this
> >>>>point?
> >>Well, I mean it as follows:
> >>
> >>Doesn't the writeback code (invoked via sync_filesystem(sb)) write
> >>all the dirty pages of all the _dirty_ inodes of a superblock?
> >>
> >>So in the window from the point where ext4_page_mkwrite returns to
> >>__do_fault() _till_ you mark the inode dirty (in
> >>__mark_inode_dirty()), you can have a race with freeze i.e if freeze
> >>happens meanwhile, then the sync initiated by freeze will not
> >>consider this locked page as the owner inode is _clean_ (or not
> >>dirtied yet) at that point?
> >   Ah, I see. That's actually a good point! Thanks for persistence. So we
> >should also dirty the page before checking for frozen fs.
> 
> Should we not also dirty the inode? IMHO, marking an inode will be
> racy as well!
  Marking the page dirty marks the inode dirty as well as I've explained in my
previous emails. So I'm missing what you are concerned about...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
