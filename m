From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] fiemap support for ext3
Date: Thu, 24 Apr 2008 08:59:57 -0600
Message-ID: <20080424145957.GO3095@webber.adilger.int>
References: <20080423193914.GA25173@unused.rdu.redhat.com>
 <20080423232725.GK3095@webber.adilger.int>
 <20080424025803.GM3095@webber.adilger.int>
 <20080424123600.GB25173@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33842 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYDXPAK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Apr 2008 11:00:10 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3OF094Y001559
	for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2008 08:00:09 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZU000013ZEL600@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 24 Apr 2008 08:00:09 -0700 (PDT)
In-reply-to: <20080424123600.GB25173@unused.rdu.redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 24, 2008  08:36 -0400, Josef Bacik wrote:
> I'm wondering if we should add a flag to the FIEMAP stuff to specify
> wether the inode you are mapping does truly have extents or if its just
> more of a block map.  Do you think something like that would be usefull?

You can already do lsattr (EXT*_IOC_GETFLAGS) on a file to determine if
it is using extents:

# lsattr /mnt/tmp/O/0/d0/459808 
-------------e /mnt/tmp/O/0/d0/459808


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

