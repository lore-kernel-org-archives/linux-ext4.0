From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, RFC] jbd2: Add commit time into the commit block
Date: Tue, 25 Mar 2008 16:38:21 -0400
Message-ID: <20080325203821.GO16358@mit.edu>
References: <1205629144-25994-1-git-send-email-tytso@mit.edu> <1206471469.3617.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63063 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551AbYCYUic (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Mar 2008 16:38:32 -0400
Content-Disposition: inline
In-Reply-To: <1206471469.3617.5.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 25, 2008 at 11:57:49AM -0700, Mingming Cao wrote:
> On Sat, 2008-03-15 at 20:59 -0400, Theodore Ts'o wrote:
> > Carlo Wood has demonstrated that it's possible to recover deleted
> > files from the journal.  Something that will make this easier is if we
> > can put the time of the commit into commit block.
> > 
> Sounds good. Added to the patch queue after fix the compile error.
> 
> Shouldn't this a JBD2 INCOMPAT feature?

No, because we're just writing some extra data at the end of the
commit record.  There's no imcompatibility implied, since both the
kernel and e2fsck will ignore the extra information.

This is the same reasoning used for why we can add new superblock
fields without needing new compatibility flags, as long as a default
value of 0 does something sane.

						- Ted

