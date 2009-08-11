From: Eric Sandeen <sandeen@redhat.com>
Subject: RFC: guard against more "dangerous" userspace options
Date: Tue, 11 Aug 2009 15:43:24 -0500
Message-ID: <4A81D7EC.2060706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46896 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbZHKUnY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2009 16:43:24 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n7BKhP5L017361
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 16:43:25 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7BKhPJr031951
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 16:43:25 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n7BKhODo031676
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 16:43:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'll keep it short and sweet:

Can we add a consistent "--eatmydata" type of hurdle to jump over before
people are allowed to use either the so-far-less-tested tools and/or
options therein?

I'm thinking of, so far:

e4defrag
mkfs.ext4 -O meta_bg (?)
mkfs.ext4 -E lazy_itable_init=1
tune2fs -I <bigger>

without the --eatmydata option (feel free to edit for clarity) we could
get something like:

"The ____ option is experimental and/or incomplete, and should be used
only for testing at this point.  Please re-issue your command with
'--eatmydata' option to use this option."

Thoughts?

I'm nervous about ext4 coming into wider use and people finding some of
the bits which aren't -quite- ready for prime time yet, and winding up
with a disaster.

Thanks,

-Eric
