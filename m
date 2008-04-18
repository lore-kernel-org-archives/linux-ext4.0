From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Fri, 18 Apr 2008 12:38:29 -0700
Message-ID: <1208547509.9475.13.camel@localhost.localdomain>
References: <20080415161430.GC28699@duck.suse.cz>
	 <1208282932.3636.9.camel@localhost.localdomain>
	 <20080416093803.GB6116@duck.suse.cz>
	 <20080418185447.GA3424@webber.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51693 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759760AbYDRTib (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2008 15:38:31 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3IJeZMe021936
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 15:40:35 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3IJcT0o254938
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 15:38:29 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3IJcTNV018727
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 15:38:29 -0400
In-Reply-To: <20080418185447.GA3424@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-04-18 at 12:54 -0600, Andreas Dilger wrote:
> On Apr 16, 2008  11:38 +0200, Jan Kara wrote:
> > On Tue 15-04-08 11:08:52, Mingming Cao wrote:
> > > I guess this reserve locking ordering allows support writepages() for
> > > ext3/4? What other the benefits?
> >
> >   Yes, that is one advantage. The other one (which I care about the most)
> > is that transaction commit code can take page_lock in the new locking order
> > which is necessary for the new ordered mode rewrite.
> 
> My understanding is that the main reason for the ordered mode rewrite is
> specifically to allow delalloc to still support ordered mode semantics.
> If the lock ordering is changed, and the jbd ordered mode is changed, but
> we don't support that with delalloc then we will have made a lot of changes
> (and likely introduced some bugs) with little benefit.
> 
> My apologies in advance if I misunderstand, and delalloc will be supported
> with these changes.
> 
I agrees with you that if we rewrite a new ordered mode(separate from
this one), we should make it possible to work with delalloc. 

Just want to clarify that the inversing locking patch proposed here
could work delalloc(just the lock ordering. I have updated delalloc to
work for the inversed locking. Just FYI I have merged the inverse
locking patches for ext4 to the unstable ext4 patche queue to see how it
goes.


Mingming

