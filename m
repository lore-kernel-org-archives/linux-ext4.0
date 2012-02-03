From: WIMPy <wimpy@yeti.dk>
Subject: Re: [dm-devel] can't recover ext4 on lvm from =?utf-8?b?ZXh0NF9tYl9nZW5lcmF0ZV9idWRkeTo3Mzk6?= group 1687, 32254 clusters in bitmap, 32258 in gd
Date: Fri, 3 Feb 2012 05:30:05 +0000 (UTC)
Message-ID: <loom.20120203T055930-479@post.gmane.org>
References: <217150909.20120105113759@eikelenboom.it> <197607646.20120105142107@eikelenboom.it> <6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu> <4910694144.20120105171428@eikelenboom.it> <20120105181535.GB26382@thunk.org> <Pine.LNX.4.64.1201061133140.6954@hs20-bc2-1.build.redhat.com> <loom.20120128T050950-718@post.gmane.org> <loom.20120128T090712-530@post.gmane.org> <EBC820CD-E86F-48BB-ADA3-38B5C8A75187@dilger.ca> <loom.20120128T162211-867@post.gmane.org> <loom.20120128T215220-189@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36955 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab2BCFaS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Feb 2012 00:30:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1RtBix-0004jp-SH
	for linux-ext4@vger.kernel.org; Fri, 03 Feb 2012 06:30:16 +0100
Received: from e183095026.adsl.alicedsl.de ([85.183.95.26])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 03 Feb 2012 06:30:15 +0100
Received: from wimpy by e183095026.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 03 Feb 2012 06:30:15 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

WIMPy <WIMPy <at> yeti.dk> writes:

> ... and another update:

I don't know what the cause is, but I think I've got the trigger.
Those errors appeared when using rsync on a directory containing a file that was 
written to (extended) while the rsync was running, which seems to be a 
situation, where rsync causes a lot of stress. It certainly takes a hell of a 
lot of time.

I suspect any of the ext4 related commits from Jan 9th/10th. From the log I 
guess they should still exist in 3.3-rc1. I'm currently testing that, but 
unfortunately that might take some time.

And a short repeat: I'm using an md, but no lvm.

  Greetings,
    WIMPy


