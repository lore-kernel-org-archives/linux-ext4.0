From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Tue, 25 Sep 2007 22:35:28 +0100
Message-ID: <20070925213528.GA11088@infradead.org>
References: <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org> <20070924092539.GC2819@petra.dvoda.cz> <20070924124035.GA4209@thunk.org> <20070925091400.GA2806@petra.dvoda.cz> <1190715083.3373.79.camel@lov.localdomain> <20070925123454.GE2806@petra.dvoda.cz> <1190751950.3773.23.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karel Zak <kzak@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4@vger.kernel.org,
	List util-linux-ng <util-linux-ng@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59318 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbXIYVfd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 17:35:33 -0400
Content-Disposition: inline
In-Reply-To: <1190751950.3773.23.camel@lov.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 25, 2007 at 10:25:50PM +0200, Kay Sievers wrote:
> >  Technical details :-)
> 
> What do you miss, these are all technical details. :) In simple words,
> we need a completely policy-free, not try-to-be-smart in any sense set
> of functions to identify a bytestream by magic bytes.

Which is exactly what mount and fsck should be doing aswell for a given
device.  In addition they also have the need to find a device if the
fstab line is identified with  LABEL and UUID.  But these are rather
separate issues.

> Hmm, only if you reaqlly don't want to pull it in util-linux, we could
> have it as a separate tree. I still think util-linux is the best place,
> because the most important user of it is mount/fsck. It's your call, I
> would have no problem sending patches against util-linux. :)

Shipping this with util-linux would make some sense.  Then again I'm
a big fan of not mixing up shared libraries and binaries in the same
package.  This just means the distros have to split them into separate
packages again.
