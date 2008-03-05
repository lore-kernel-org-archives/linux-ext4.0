From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFC PATCH] ext4: Use page_mkwrite vma_operations to get mmap
	write notification.
Date: Wed, 5 Mar 2008 18:59:41 -0500
Message-ID: <20080305235941.GD18188@mit.edu>
References: <1204634542-16599-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204677951.3605.6.camel@localhost.localdomain> <20080305232927.GC18188@mit.edu> <1204760238.3713.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61719 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501AbYCEX74 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Mar 2008 18:59:56 -0500
Content-Disposition: inline
In-Reply-To: <1204760238.3713.4.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 05, 2008 at 03:37:18PM -0800, Mingming Cao wrote:
> On Wed, 2008-03-05 at 18:29 -0500, Theodore Tso wrote:
> > On Tue, Mar 04, 2008 at 04:45:51PM -0800, Mingming Cao wrote:
> > > > +	/* FIXME!! should we take inode->i_mutex ? Currently we can't because
> > > > +	 * it has a circular locking dependency with DIO. But migrate expect
> > > > +	 * i_mutex to ensure no i_data changes
> > 
> > Should I worry that we have something in the stable part of the patch
> > queue with this FIXME!! comment?  :-)
> > 
> 
> I think this comment could be moved to the migration.c. We can't take
> i_mutex on mapped IO path. The i_data_mutex is the lock that should
> protect the i_data concurrent changes, which is currently mapped IO
> used. The race with migration could be addressed in migration instead of
> here. I propose we drop this comment for now.

OK, but that still means we have a known bug in the migration code,
which is in mainline....

						- Ted
