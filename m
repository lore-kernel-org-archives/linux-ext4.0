From: Brian Candler <B.Candler@pobox.com>
Subject: Kernel panic from corrupt journal
Date: Thu, 30 Aug 2012 10:22:12 +0100
Message-ID: <20120830092212.GB12981@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:39402 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2H3JWR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2012 05:22:17 -0400
Received: from smtp.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 9DFAF7301
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2012 05:22:16 -0400 (EDT)
Received: from b-pb-sasl-quonix.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 8BBC57300
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2012 05:22:16 -0400 (EDT)
Received: from Brians-MacBook-Air.local (unknown [87.112.176.34]) (using
 TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client certificate
 requested) by b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id 283A272FF for
 <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2012 05:22:16 -0400 (EDT)
Received: from brian by Brians-MacBook-Air.local with local (Exim 4.77)
 (envelope-from <b.candler@pobox.com>) id M9KA10-000A1F-9Q for
 linux-ext4@vger.kernel.org; Thu, 30 Aug 2012 10:22:12 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have a system where just replaying the journal causes a kernel panic. If I
boot into recovery mode and then type

    # fsck -y /dev/sda8

it says it's recovering the journal, then a second or two later I get a
panic traceback.  Unfortunately there are only 24 lines displayed on the
screen; my scribbled notes give the top and bottom ones as

    req_bios_endio.isra.45+0xa3/0xe0
    ...
    start_secondary+0xd8/0xdb

I can get a screenshot of this if it's useful to anyone.

With "debugfs /dev/sda8", then:

    logdump /tmp/sda8.dmp      -> this works OK, writes out a list of blocks
    logdump -ac /tmp/sda8.dmp  -> this also causes a kernel panic!

So:

(1) the fact that I can cause a kernel panic is a bug, and if I can help fix
it I will; however I'm not sure how I can pass on any useful information
given that even dumping the journal causes a kernel panic.  Can I get the
journal by dd'ing at a specific offset?

(2) I'd also like to be able to recover this filesystem, e.g. by clearing
the journal, but I haven't been able to find out how to do this.

The best I can find by googling is to try mounting with ro,noload. I'll give
this a go to see if I can backup the filesystem, but otherwise it looks like
I may have to reformat the partition and restore.

Background info: this system is a Dell Zino HD running Ubuntu 12.04 (fully
patched as of 29 Aug 2012, standard 3.2.0-xx kernel).  My wife accidentally
chose "suspend" rather than "shutdown" to turn it off yesterday, and it
failed to boot this morning.

Regards,

Brian.
