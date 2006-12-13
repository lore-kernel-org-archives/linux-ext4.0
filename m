From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Wed, 13 Dec 2006 17:54:06 +0300
Message-ID: <m3odq7zw1d.fsf@bzzz.home.net>
References: <m3vekwtqnp.fsf@bzzz.home.net> <45800965.2080005@bull.net>
	<m3wt4vzxje.fsf@bzzz.home.net> <45801018.1090001@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:37132 "EHLO gw.home.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S964972AbWLMOyY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Dec 2006 09:54:24 -0500
To: Valerie Clement <valerie.clement@bull.net>
In-Reply-To: <45801018.1090001@bull.net> (Valerie Clement's message of "Wed\,
	13 Dec 2006 15\:37\:12 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Valerie Clement (VC) writes:

 VC> Alex Tomas wrote:
 >>>>>>> Valerie Clement (VC) writes:
 >> 
 VC> Hi Alex,
 VC> I did the following test:
 VC> # mkfs /dev/sdc1
 VC> # mount -t ext4dev -o extents,mballoc,delalloc /dev/sdc1 /test
 VC> # dumpe2fs -h /dev/sdc1
 VC> # cp linux.tar /test
 VC> # tar xf /test/linux.tar
 VC> # dumpe2fs -h /dev/sdc1
 >> 
 VC> The "Free blocks" and "Free inodes" counters in the dumpe2fs output
 VC> did not change after running the cp and tar commands.
 >> 
 >> sync should help, I think.

 VC> No, I've just tried, it does not change anything.

ah, it's simple. you're looking at superblock counters.
we don't update them every time. this was changed years
ago. try the same with regular ext3

thanks, Alex
