From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Tue, 26 Aug 2008 16:00:28 -0400
Message-ID: <20080826200028.GA29936@mit.edu>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home> <20080826144721.GD8720@mit.edu> <20080826194445.GN3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karel Zak <kzak@redhat.com>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>, mbroz@redhat.com,
	agk@redhat.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39757 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753869AbYHZUAb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 16:00:31 -0400
Content-Disposition: inline
In-Reply-To: <20080826194445.GN3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2008 at 01:44:45PM -0600, Andreas Dilger wrote:
> On Aug 26, 2008  10:47 -0400, Theodore Ts'o wrote:
> > I don't think you mean multipath support in terms of where there are
> > multiple paths to the same physical device ala fiber channel, but
> > rather where are multiple devices which are built on each other,
> > right?  So where /dev/sda is used to create the LVM PV's, and so on,
> > right?
> 
> No, in fact DM has actual mutliple-paths-to-the-same-device support,
> via "dm-multipath".

Well, *that* we have, as long as the parent devices are real
(non-devicemapper) devices.

So if /dev/sdc and /dev/sdg are both paths to the same filesystem, and
dm-multipath has created /dev/mapper/filesystem as the multipath
device to that filesystem, any devices with /dev/mapper have priority
over non-dm devices, so /dev/mapper/filesystem will get returned
first.

					- Ted
