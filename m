From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Wed, 14 Jan 2009 18:27:50 +0100
Message-ID: <20090114172750.GJ19950@duck.suse.cz>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081218231707.GB20092@atrey.karlin.mff.cuni.cz> <496D1233.2060905@redhat.com> <20090114042402.GH14730@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vg
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45739 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755892AbZANR1w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 12:27:52 -0500
Content-Disposition: inline
In-Reply-To: <20090114042402.GH14730@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 13-01-09 23:24:02, Theodore Tso wrote:
> On Tue, Jan 13, 2009 at 04:14:11PM -0600, Eric Sandeen wrote:
> > 
> > This looks sane to me, and it does fix the below testcase.
> > 
> > Care to formally propose it?
> 
> Can we confirm what is being proposed?  From following this thread, I
> think what folks are suggesting is:
> 
> 1)  Revert the current "ext3/4: wait on all pending ocmmits in ext3/4_sync_fs"
  Yes.

> 2)  Apply Jan's patch "jbd[2]: Fix return value of journal_start_commit()"
  Yes.

> 3)  Also apply Jan's patch "jbd2: Skip commit of a transaction without
> any buffers" since it appears to be a good optimization (although it's
> not clear it would happen once we revert (1), above.
  Yes, it's an optimization but I'm still a bit afraid about something
relying on jbd2_journal_force_commit() implying a barrier which would not
always be a case after this patch... So we should probably audit all users of
ext4_force_commit() and check that this change is fine with them.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
