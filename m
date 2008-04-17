From: Andreas Dilger <adilger@sun.com>
Subject: Re: Ininitial e2fsprogs TODO list (please expand)
Date: Wed, 16 Apr 2008 21:26:52 -0600
Message-ID: <20080417032652.GD3473@webber.adilger.int>
References: <20080415115216.1f6868de@gara.konoha.net>
 <20080416033002.GZ3106@webber.adilger.int>
 <20080415233510.11f9179f@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60248 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYDQD06 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2008 23:26:58 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3H3Qv2E027845
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 20:26:57 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZG000019IP5T00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 16 Apr 2008 20:26:57 -0700 (PDT)
In-reply-to: <20080415233510.11f9179f@gara.konoha.net>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 15, 2008  23:35 -0500, Jose R. Santos wrote:
> On Tue, 15 Apr 2008 21:30:02 -0600
> Andreas Dilger <adilger@sun.com> wrote:
> > Something was lost in translation here.  The uninit_groups feature DOES
> > zero the inode tables by default, and marks the groups with ITABLE_ZEROED.
> > It is only if "-O uninit_groups,lazy_bg" are both given at the same time
> > that the itable is not initialized.  That is no different than if lazy_bg
> > was given by itself.
> 
> Yes, I understand this part.
>  
> > So nothing needs to be done in e2fsprogs until some time after the kernel
> > is updated to do the zeroing.
> 
> The problem is that not initializing the inode table on the uninit
> block group patch depends on a feature (lazy_bg) that Ted wants
> removed.  I believe that just removing the lazy_bg feature would be
> enough to remove this capability from the uninit patch, but was not
> entirely sure so I put the item just to keep track of it.
> 
> If lazy_bg is in fact removed from e2fsprogs, I suppose we need to add
> another item to enable lazy setup of the inode tables once the proper
> support in the kernel is establish.

Yes, the "lazy init" for uinint_groups will essentially be identical to
what we have in lazy_bg today.  So if we are disabling lazy_bg as a
user-selectable option, we should leave the code in place for later use.
I wouldn't object to requiring a user to specify "mke2fs -O FEATURE_C6"
to enable it.  That keeps it out of the hands of newbies, but leaves the
capability to test large filesystems w/o 45 minute mke2fs times.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

