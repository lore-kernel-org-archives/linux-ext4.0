From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] ext4: Use page_mkwrite vma_operations to get mmap
	write notification.
Date: Wed, 05 Mar 2008 15:37:18 -0800
Message-ID: <1204760238.3713.4.camel@localhost.localdomain>
References: <1204634542-16599-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1204677951.3605.6.camel@localhost.localdomain>
	 <20080305232927.GC18188@mit.edu>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52070 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbYCEXhv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Mar 2008 18:37:51 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m25NbnTf003204
	for <linux-ext4@vger.kernel.org>; Wed, 5 Mar 2008 18:37:49 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m25Nbn9w243372
	for <linux-ext4@vger.kernel.org>; Wed, 5 Mar 2008 18:37:49 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m25NbmZS020712
	for <linux-ext4@vger.kernel.org>; Wed, 5 Mar 2008 18:37:48 -0500
In-Reply-To: <20080305232927.GC18188@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-03-05 at 18:29 -0500, Theodore Tso wrote:
> On Tue, Mar 04, 2008 at 04:45:51PM -0800, Mingming Cao wrote:
> > > +	/* FIXME!! should we take inode->i_mutex ? Currently we can't because
> > > +	 * it has a circular locking dependency with DIO. But migrate expect
> > > +	 * i_mutex to ensure no i_data changes
> 
> Should I worry that we have something in the stable part of the patch
> queue with this FIXME!! comment?  :-)
> 

I think this comment could be moved to the migration.c. We can't take
i_mutex on mapped IO path. The i_data_mutex is the lock that should
protect the i_data concurrent changes, which is currently mapped IO
used. The race with migration could be addressed in migration instead of
here. I propose we drop this comment for now.

Mingming

