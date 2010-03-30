From: tytso@mit.edu
Subject: Re: Should journaled quota be default for ext4?
Date: Mon, 29 Mar 2010 22:10:08 -0400
Message-ID: <20100330021008.GB7628@thunk.org>
References: <4BAC3860.7010905@redhat.com>
 <20100326142626.GI21658@thunk.org>
 <20100330011750.GC18791@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53360 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab0C3CKe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 22:10:34 -0400
Content-Disposition: inline
In-Reply-To: <20100330011750.GC18791@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 30, 2010 at 03:17:50AM +0200, Jan Kara wrote:
>   Yes, quota-tools currently use these options as well to detect whether they
> should run the command on the filesystem or not. The problem is that at least
> "quotaon -a" needs to know on which filesystem it should run and currently it
> uses quota mount options to decide. I can change quota tools to just look for
> quota files but that's not guaranteed to succeed because for unjournaled
> quotas, quota files could be anywhere - even on a different filesystem - and I
> really know admins who use such setup.

Hmm.... so is this something we need to continue to support?  If we
phase out support for anything other than hidden journal files, that
implies that these sysadmins would eventually need to ove, right?

> And for journaled quotas, file name
> of the quota file is the one given in the {usr,grp}jquota mount option
> so without it it's impossible to locate the quota file as well.

... and sometimes names other than aquota.user and aquota.group are
used?  I was thinking about having e2fsck look for those file names,
maybe check the format, and then offer to auto-convert them to the new
format with hidden quota files.  I suppose I could have e2fsck try to
look for that information in /etc/fstab, but that adds a different
layer of complexity (namely, we need to be confident we can match up a
particular device with an /etc/fstab entry, which usually but doesn't
always work).

>   So I think the easiest way out of this is really to make quota
> files hidden as we discussed in another thread. Then kernel always
> knows whether the filesystem accounts quotas or not and quota tools
> can ask it with GETFMT quotactl.

I agreee, long term that will be the right answer.

I just realized that since ext4 does support a nojournal mode, we will
also need to support a no-journal mode with the hidden quota file, but
that's not a big deal if e2fsck handles checking the file system
consistency as well as rebuilding the quota in-use information for the
hidden quota file.

					- Ted
