From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 22 Dec 2008 15:57:57 -0700
Message-ID: <20081222225757.GV5000@webber.adilger.int>
References: <4908C951.2000309@redhat.com>
 <20081103184426.GA31894@ajones-laptop.nbttech.com>
 <20081103113318.35b0c266.akpm@linux-foundation.org>
 <20081103201428.GB30565@ajones-laptop.nbttech.com>
 <20081218231707.GB20092@atrey.karlin.mff.cuni.cz>
 <494ADEB3.8010109@redhat.com> <20081219002752.GE8424@duck.suse.cz>
 <494AFA16.2010004@redhat.com> <494FE73E.5000802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:40774 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbYLVW6O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Dec 2008 17:58:14 -0500
In-reply-to: <494FE73E.5000802@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 22, 2008  14:15 -0500, Ric Wheeler wrote:
> Without having dived into the patch in detail, one worry I would have is  
> that we still might care to spin up a drive for empty transactions in  
> order to invalidate the drive's write cache.
>
> For example, if we have the following sequence:
>
>    (1) user app performs series of writes to file A
>    (2) pages dirtied from writes to A are destaged to the disk over time
>    (3) user app issues fsync(file A) to make sure that the data will  
> survive a power outage
>
> At this point in time, would this change prevent us from spinning up the  
> drive and invalidating the disk write cache for that fsync() ?

Well, if the writes themselves didn't spin up the drive, it is uncertain
whether the write of the journal commit block would be any more helpful
in getting that to happen.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

