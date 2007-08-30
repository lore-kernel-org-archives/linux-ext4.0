From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: ZFS, XFS, and EXT4 compared
Date: Thu, 30 Aug 2007 14:14:04 -0500
Message-ID: <46D716FC.9030905@sandeen.net>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>	 <1188457666.24970.94.camel@edge.yarra.acx>	 <20070830132002.GA4086@infradead.org>  <46D71318.2050604@sandeen.net> <1188500941.8980.20.camel@toonses.gghcwest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:18294 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbXH3TNw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2007 15:13:52 -0400
In-Reply-To: <1188500941.8980.20.camel@toonses.gghcwest.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jeffrey W. Baker wrote:
> On Thu, 2007-08-30 at 13:57 -0500, Eric Sandeen wrote:

>> barrier seems to hurt badly on xfs, too.  Note: barrier is off by
>> default on ext[34], so if you want apples to apples there, you need to
>> change one or the other filesystem's mount options.  If your write cache
>> is safe (battery backed?) you may as well turn barriers off.  I'm not
>> sure offhand who will react more poorly to an evaporating write cache
>> (with no barriers), ext4 or xfs...
> 
> I didn't compare the safety of the three filesystems, 

Understood

> but I did have
> disk caches disabled 

Oh, so for the SW raid tests the individual disks had no write cache?f

> and only battery-backed caches enabled.  Do you
> need barriers without volatile caches?

As far as I understand it, then nope, you don't need it, and you're
hurting performance with it.

-Eric
