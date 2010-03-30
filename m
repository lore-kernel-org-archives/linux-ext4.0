From: Jan Kara <jack@suse.cz>
Subject: Re: Should journaled quota be default for ext4?
Date: Tue, 30 Mar 2010 04:24:47 +0200
Message-ID: <20100330022447.GF18791@atrey.karlin.mff.cuni.cz>
References: <4BAC3860.7010905@redhat.com> <20100326142626.GI21658@thunk.org> <20100330011750.GC18791@atrey.karlin.mff.cuni.cz> <20100330021008.GB7628@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51800 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753276Ab0C3CYs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 22:24:48 -0400
Content-Disposition: inline
In-Reply-To: <20100330021008.GB7628@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Tue, Mar 30, 2010 at 03:17:50AM +0200, Jan Kara wrote:
> >   Yes, quota-tools currently use these options as well to detect whether they
> > should run the command on the filesystem or not. The problem is that at least
> > "quotaon -a" needs to know on which filesystem it should run and currently it
> > uses quota mount options to decide. I can change quota tools to just look for
> > quota files but that's not guaranteed to succeed because for unjournaled
> > quotas, quota files could be anywhere - even on a different filesystem - and I
> > really know admins who use such setup.
> 
> Hmm.... so is this something we need to continue to support?  If we
> phase out support for anything other than hidden journal files, that
> implies that these sysadmins would eventually need to ove, right?
  Yes, they will be forced to move. Honestly, I never heard a good technical
reason for this so hopefully it won't be a big pain for them. But sure we have
to provide a long enough period where we only warn about deprecation so that we
can get some decent feedback.

> > And for journaled quotas, file name
> > of the quota file is the one given in the {usr,grp}jquota mount option
> > so without it it's impossible to locate the quota file as well.
> 
> ... and sometimes names other than aquota.user and aquota.group are
> used?
  Sadly yes, although I expect this to be rather rare.

> I was thinking about having e2fsck look for those file names, maybe check the
> format, and then offer to auto-convert them to the new format with hidden
> quota files.  I suppose I could have e2fsck try to look for that information
> in /etc/fstab, but that adds a different layer of complexity (namely, we need
> to be confident we can match up a particular device with an /etc/fstab entry,
> which usually but doesn't always work).
  Alternatively, you could have an option where admin could provide filenames
of quota files for conversion if e2fsck cannot find them on its own. It
wouldn't be automated but it would still provide a reasonable transition
path.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
