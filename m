From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Thu, 31 May 2007 17:01:08 -0500
Message-ID: <465F45A4.9010904@redhat.com>
References: <20070512020248.GQ6375@schatzie.adilger.int> <20070524114442.GA12526@schatzie.adilger.int> <46559E04.5060002@clusterfs.com> <20070531162109.GA23591@thunk.org> <20070531201902.GF5181@schatzie.adilger.int> <20070531213301.GC13660@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Rupesh Thakare <rupesh@clusterfs.com>,
	linux-ext4@vger.kernel.org, Kalpak Shah <kalpak@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbXEaWBN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2007 18:01:13 -0400
In-Reply-To: <20070531213301.GC13660@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> And has anyone investigated where there are
> magic ioctl's or libdevmapper APi's so we can get the RAID parameters
> automatically?  If so, patches so that mke2fs can get the information
> automatically (as opposed to forcing the user to have to specify lots
> of annoying options) would be most welcome....

xfsprogs has a libdisk which does this for evms, lvm, md, dm, and xvm(!)

see for example md_get_subvol_stripe() in xfsprogs.

-Eric
