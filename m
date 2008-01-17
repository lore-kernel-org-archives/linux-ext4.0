From: Eric Sandeen <sandeen@redhat.com>
Subject: why are acls & user xattrs off by default?
Date: Wed, 16 Jan 2008 20:46:16 -0600
Message-ID: <478EC178.2050609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYAQCqS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jan 2008 21:46:18 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m0H2kH1R004832
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2008 21:46:18 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0H2kHZh020455
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2008 21:46:17 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0H2kGJa021357
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2008 21:46:17 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was looking through Anaconda to see what it's doing when it makes ext3
filesystems:

        rc = iutil.execWithRedirect("tune2fs",
                                    ["-c0", "-i0", "-Odir_index",
                                     "-ouser_xattr,acl", devicePath],
                                    stdout = "/dev/tty5",
                                    stderr = "/dev/tty5", searchPath = 1)

-Odir_index is redundant by now; it's default in e2fsprogs.

-c0 -i0 are probably subject to some debate, but...

why are user_xattr & acl required to be mount options for ext3?  (added
to defaults or explicit?)  I'm sure there is some history here, but why
build it all into the module, and then turn them off without some extra
magic passed in?  What's the advantage to disabling user xattrs & acls
at runtime by default?

Thanks & just curious,

-Eric
