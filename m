From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
Date: Wed, 11 Jan 2012 01:04:48 +0100
Message-ID: <20120111000448.GA16395@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
 <1323367477-21685-2-git-send-email-kamal@canonical.com>
 <4F0C9D87.8010006@sandeen.net>
 <20120110213104.GI4516@quack.suse.cz>
 <CAMBkX3eVeKSmEzmYTe6Oe_D6kAMQTL5LYoi1-Axj7CcrM85Pow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
	Kamal Mostafa <kamal@canonical.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Surbhi Palande <surbhi.palande@canonical.com>
To: Surbhi Palande <csurbhi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971Ab2AKAEv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 19:04:51 -0500
Content-Disposition: inline
In-Reply-To: <CAMBkX3eVeKSmEzmYTe6Oe_D6kAMQTL5LYoi1-Axj7CcrM85Pow@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 10-01-12 13:50:22, Surbhi Palande wrote:
> > > Hrm let me think through this a little more; we actually do:
> > >
> > > t16) ext4_journal_start()
> > >   t17) ext4_journal_start_sb()
> > >     t18) handle = ext4_journal_current_handle();
> > >     t19) if (!handle) vfs_check_frozen()
> > >     t20) ... jbd2_journal_start()
> >   Ah, right. I forgot.
> >
> > > So actually we *do* block new handles, but let *existing* ones
> > > continue (see commits 6b0310fbf087ad6e9e3b8392adca97cd77184084
> > > and be4f27d324e8ddd57cc0d4d604fe85ee0425cba9)
> > >
> > > So your assertion that a new handle is started is incorrect
> > > in general, isn't it?  So then does the fix seem necessary?
> > > Or, at least, in the fashion below - maybe we need to just make
> > > sure all started handles complete before the unlock_updates?
> > > Or am I missing something...?
> >   Well, the problem with running operations and freezing is more
> > fundamental I believe. See my email
> > http://marc.info/?l=linux-fsdevel&m=132585911925796&w=2
> >
> > So I believe we'll need some better exclusion mechanism already in VFS.
> >
> >                                                                Honza
> >
> 
> 
> If all the write operations were journaled, then this patch would not allow
> ext4 filesystem to have any dirty data after its frozen.
> (as journal_start() would block).
> 
>  I think the only one candidate that creates dirty data without calling
> ext4_journal_start() is mmapped?
  No, the problem is in any write path. The problem is with operations
that happen during the phase when s_frozen == SB_FREEZE_WRITE. These
operations dirty the filesystem but running sync may easily miss them.
During this phase journal is not frozen so that does not help you in any
way.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
