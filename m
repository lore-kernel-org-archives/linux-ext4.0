From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Wed, 13 Dec 2006 17:21:41 +0300
Message-ID: <m3wt4vzxje.fsf@bzzz.home.net>
References: <m3vekwtqnp.fsf@bzzz.home.net> <45800965.2080005@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:40889 "EHLO gw.home.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S964774AbWLMO3G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Dec 2006 09:29:06 -0500
To: Valerie Clement <valerie.clement@bull.net>
In-Reply-To: <45800965.2080005@bull.net> (Valerie Clement's message of "Wed\,
	13 Dec 2006 15\:08\:37 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Valerie Clement (VC) writes:

 VC> Hi Alex,
 VC> I did the following test:
 VC> # mkfs /dev/sdc1
 VC> # mount -t ext4dev -o extents,mballoc,delalloc /dev/sdc1 /test
 VC> # dumpe2fs -h /dev/sdc1
 VC> # cp linux.tar /test
 VC> # tar xf /test/linux.tar
 VC> # dumpe2fs -h /dev/sdc1

 VC> The "Free blocks" and "Free inodes" counters in the dumpe2fs output
 VC> did not change after running the cp and tar commands.

sync should help, I think.

 VC> I think it misses a call to ext4_commit_super() at the end of the
 VC> ext4_lg_sync_inodes function.
 VC> Am I right ?

what for? allocation was delayed, no blocks were allocated.

thanks, Alex
