From: Andreas Dilger <adilger@sun.com>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Fri, 18 Apr 2008 12:54:47 -0600
Message-ID: <20080418185447.GA3424@webber.adilger.int>
References: <20080415161430.GC28699@duck.suse.cz>
 <1208282932.3636.9.camel@localhost.localdomain>
 <20080416093803.GB6116@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62373 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYDRSy6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Apr 2008 14:54:58 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3IIsuxn013182
	for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2008 11:54:57 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZJ00001AKE6T00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 18 Apr 2008 11:54:56 -0700 (PDT)
In-reply-to: <20080416093803.GB6116@duck.suse.cz>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 16, 2008  11:38 +0200, Jan Kara wrote:
> On Tue 15-04-08 11:08:52, Mingming Cao wrote:
> > I guess this reserve locking ordering allows support writepages() for
> > ext3/4? What other the benefits?
>
>   Yes, that is one advantage. The other one (which I care about the most)
> is that transaction commit code can take page_lock in the new locking order
> which is necessary for the new ordered mode rewrite.

My understanding is that the main reason for the ordered mode rewrite is
specifically to allow delalloc to still support ordered mode semantics.
If the lock ordering is changed, and the jbd ordered mode is changed, but
we don't support that with delalloc then we will have made a lot of changes
(and likely introduced some bugs) with little benefit.

My apologies in advance if I misunderstand, and delalloc will be supported
with these changes.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

