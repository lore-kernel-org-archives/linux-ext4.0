From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_flush_completed_IO wait semantics
Date: Wed, 3 Oct 2012 16:24:38 -0400
Message-ID: <20121003202438.GA6026@thunk.org>
References: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org>
 <20121003185558.GB5160@thunk.org>
 <87lifns65w.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53646 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab2JCUYo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Oct 2012 16:24:44 -0400
Content-Disposition: inline
In-Reply-To: <87lifns65w.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 03, 2012 at 11:32:27PM +0400, Dmitry Monakhov wrote:
> On Wed, 3 Oct 2012 14:55:58 -0400, "Theodore Ts'o" <tytso@mit.edu> wrote:
> > Are you planning on updating the 'ext4: completed_io locking cleanup
> > V4' patch series, or is this an additional patch that should be tacked
> > on to it?
> This is addidional patch which should be placed on top of
> 'ext4: completed_io locking cleanup V4'
> I'll try to convince Jan Kara that this is the best way to fix both bugs.

OK, thanks.  I've been making the spelling/typo fixes suggested by Jan
to the commits in my tree.  So we're up to date on that front.  I just
wanted to know if there were any other changes you think were
necessary to the patch series.

I'll add the completed_io locking cleanup to my patch series, and
start running tests....

						- Ted

