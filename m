From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
Date: Wed, 11 Jan 2012 13:10:22 +0100
Message-ID: <20120111121022.GB26337@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
 <1323367477-21685-2-git-send-email-kamal@canonical.com>
 <4F0C9D87.8010006@sandeen.net>
 <20120110213104.GI4516@quack.suse.cz>
 <CAMBkX3eVeKSmEzmYTe6Oe_D6kAMQTL5LYoi1-Axj7CcrM85Pow@mail.gmail.com>
 <20120111000448.GA16395@quack.suse.cz>
 <CAMBkX3e_jyTZ=i8D8_cza23Xygd+Gf5iACZ+hbo5TaYLrJPH-Q@mail.gmail.com>
 <CAMBkX3e8CKaDh7vdqAcTH1tnye4UusPZ_XjJdNVRZcaDqZnt2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
	Kamal Mostafa <kamal@canonical.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Surbhi Palande <csurbhi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab2AKMKd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jan 2012 07:10:33 -0500
Content-Disposition: inline
In-Reply-To: <CAMBkX3e8CKaDh7vdqAcTH1tnye4UusPZ_XjJdNVRZcaDqZnt2g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 10-01-12 21:38:29, Surbhi Palande wrote:
> On second thoughts, I fail to see why there is still a race window
> after this patch.
> 
> Here are the reasons why i fail to see how the data can be dirtied
> when all the operations involve a journal:
> 
> ----------
> So here is the problem that we see
> 	CPU1						         CPU2
>        Task1 (write operation)				          Task2
> ---------------------------------------------------------------------------------------
> t1 	ext4_journal_start()
> t2	  ext4_journal_start_sb()
> t3	    vfs_check_frozen				sb->frozen=SB_FREEZE_WRITE
> t4		jbd2_journal_start()			/* hence forth all processes calling
> vfs_check_frozen will wait */
  Note that we call vfs_check_frozen(sb, SB_FREEZE_TRANS) in
ext4_journal_start_sb(). Thus we start blocking only when s_frozen ==
SB_FREEZE_TRANS and we just ignore s_frozen == SB_FREEZE_WRITE.

> Now, our aim is to stop Task1 from dirtying the page cache ie in
> starting this transaction. However if it is successful in starting
> this transaction, then we want to make sure that this transaction is
> flushed out.
> Correct?
  Not quite. Flushing a journal will flush dirty metadata but we will still
have dirty pages (dirty data is not part of any transaction). So in the
scenarion I describe in
http://marc.info/?l=linux-fsdevel&m=132585911925796&w=2
all metadata changes will be flushed inside ->freeze_fs (at least for
journalling filesystems) but pages will be left dirty. Is it clearer now?

But your comment makes me realize that the situation is simpler than I
thought by the fact that we only have to protect paths that create dirty
data as dirty metadata can be handled by flushing a journal. And there are
only a few places creating dirty data. So a reasonably clean solution
shouldn't be that complicated after all. I'll tweak my patch and try it in
a moment.

								Honza 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
