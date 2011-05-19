From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] Fix sending of a barrier and transaction waiting
 in ext4_sync_file()
Date: Thu, 19 May 2011 12:51:49 +0200
Message-ID: <20110519105149.GC8417@quack.suse.cz>
References: <1305628095-27843-1-git-send-email-jack@suse.cz>
 <20110518174327.GB20655@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	Edward Goggin <egoggin@vmware.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab1ESKwM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 May 2011 06:52:12 -0400
Content-Disposition: inline
In-Reply-To: <20110518174327.GB20655@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 18-05-11 10:43:27, Darrick J. Wong wrote:
> On Tue, May 17, 2011 at 12:28:13PM +0200, Jan Kara wrote:
> > 
> >   Hi Ted,
> > 
> >   the two patches below fix ext4_sync_file() to wait for a transaction commit
> > properly (return value of jbd2_log_start_commit() is not exactly what
> > ext4_sync_file() thinks it is). It also optimizes / fixes sending of a barrier
> > in some cases (e.g. in ordered mode with external journal we cannot really
> > depend on transaction commit to issue a barrier to fs device because we don't
> > seem to add inode to a transaction for overwrites).
> 
> Probably a silly nit to pick, but do you mean "flush" instead of "barrier"?
  Oh, right. I mean flush :). Thanks.

									Honza

> > I already fixed ext3 in this regard some time ago but didn't get to porting the
> > patches to ext4. 
> > 
> > 									Honza
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
