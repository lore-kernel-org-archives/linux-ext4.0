From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Tue, 26 Aug 2008 13:44:45 -0600
Message-ID: <20080826194445.GN3392@webber.adilger.int>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com>
 <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home>
 <20080826144721.GD8720@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Karel Zak <kzak@redhat.com>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>, mbroz@redhat.com,
	agk@redhat.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41259 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbYHZTot (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 15:44:49 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7QJim7l000071
	for <linux-ext4@vger.kernel.org>; Tue, 26 Aug 2008 12:44:48 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6800D0144Z5200@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 26 Aug 2008 12:44:48 -0700 (PDT)
In-reply-to: <20080826144721.GD8720@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 26, 2008  10:47 -0400, Theodore Ts'o wrote:
> I don't think you mean multipath support in terms of where there are
> multiple paths to the same physical device ala fiber channel, but
> rather where are multiple devices which are built on each other,
> right?  So where /dev/sda is used to create the LVM PV's, and so on,
> right?

No, in fact DM has actual mutliple-paths-to-the-same-device support,
via "dm-multipath".

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

