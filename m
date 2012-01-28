From: WIMPy <WIMPy@yeti.dk>
Subject: Re: [dm-devel] can't recover ext4 on lvm from =?utf-8?b?ZXh0NF9tYl9nZW5lcmF0ZV9idWRkeTo3Mzk6?= group 1687, 32254 clusters in bitmap, 32258 in gd
Date: Sat, 28 Jan 2012 04:53:26 +0000 (UTC)
Message-ID: <loom.20120128T050950-718@post.gmane.org>
References: <217150909.20120105113759@eikelenboom.it> <197607646.20120105142107@eikelenboom.it> <6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu> <4910694144.20120105171428@eikelenboom.it> <20120105181535.GB26382@thunk.org> <Pine.LNX.4.64.1201061133140.6954@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51962 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2A1GKJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Jan 2012 01:10:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Rr1UG-0003UL-H3
	for linux-ext4@vger.kernel.org; Sat, 28 Jan 2012 07:10:08 +0100
Received: from e183095026.adsl.alicedsl.de ([85.183.95.26])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2012 07:10:08 +0100
Received: from WIMPy by e183095026.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2012 07:10:08 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mikulas Patocka <mpatocka <at> redhat.com> writes:

> The existence of a snapshot changes I/O completion times significantly, so 
> it may be a race condition in ext4 that gets triggered which changed 
> timings.

The idea that timing might cause issues on a FS is disturbing.

> > this is a problem which apparently occurred when the user went from
> > v3.1.5 to v3.2, so this looks likes 3.2 regression.)

I am on 3.2.0 as well.

It happened for me on a freshly created FS.
"mke2fs -j -O sparse_super -O dir_index -O extents -O filetype -O uninit_bg"
mounted with no additional options for the first time I got an
"EXT4-fs error (device md127): ext4_mb_generate_buddy:739: group 28671, 32765 
clusters in bitmap, 32766 in gd"
after writing about 3TB of data.
I do not have RO snapshots as the OP, but my md sits on to of luks containers. 
So we do have the device mapper in common.

Just for the records: Unlike the contents, the hardware is not new and did not 
have any known issues.

  Greetings,
    WIMPy

