From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Wed, 27 Aug 2008 01:26:43 -0600
Message-ID: <20080827072643.GT3392@webber.adilger.int>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com>
 <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home>
 <20080826144721.GD8720@mit.edu> <20080826204737.GM6029@nb.net.home>
 <20080826233224.GB29936@mit.edu> <20080827001942.GN6029@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>, mbroz@redhat.com,
	agk@redhat.com
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62525 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYH0H0q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 03:26:46 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7R7Qj9Z017731
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 00:26:45 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6900J010HX3F00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 27 Aug 2008 00:26:45 -0700 (PDT)
In-reply-to: <20080827001942.GN6029@nb.net.home>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 27, 2008  02:19 +0200, Karel Zak wrote:
> On Tue, Aug 26, 2008 at 07:32:25PM -0400, Theodore Tso wrote:
> > you'll just be re-inventing blkid.  If you don't cache, you'll either
> 
>  Hehe.. I will directly copy code from blkid and vol_id. It's open
>  source. I needn't re-inventing ;-)

Couldn't you just change libblkid to export the probe functions?  It
always makes me cringe when code like this is copied, because I just
_know_ one or the other will become out of date, and it will take
twice as much effort to keep them in sync.  I'd rather see people
doing "high value" work instead of watching for and copying patches
around.

> > Or maybe the right answer is /proc/partitions should only export
> > devicemapper devices that are "supposed" to be visible to mount, and
> 
>  Yes, I have no clue why the dm-N crap is in /proc/partitions.
>  Probably any legacy...

I've wanted that for so long...  It's always a pain that LVM tools
work by using /dev/vgfoo/lvfoo (which is fine) but /proc/partitions
doesn't give any clue to what each dm-X device is.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

