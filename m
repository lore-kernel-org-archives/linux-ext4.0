From: Eric Sandeen <sandeen@redhat.com>
Subject: e2fsprogs 1.42-WIP busted on big endian
Date: Tue, 08 Nov 2011 10:29:25 -0600
Message-ID: <4EB958E5.3080604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab1KHQ31 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Nov 2011 11:29:27 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pA8GTQ5f027867
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 8 Nov 2011 11:29:27 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pA8GTPpP020378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 8 Nov 2011 11:29:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was noted in commit ccc7cf032852dd5c84b227bafb481b1d158e2b5e:


commit ccc7cf032852dd5c84b227bafb481b1d158e2b5e
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Jul 30 18:41:47 2010 -0400

    libext2fs: fix obvious big-endian bugs introduced by 64-bit changes
    
    These patches fix obvious bone-headed mistakes, so e2fsprogs will now
    build and mostly work on powerpc.  The m_meta_bg, u_mke2fs, and
    u_tune2fs tests are still failing, however, so there's still work to do...
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

but not fixed yet.  Just a heads up, when contemplating a 1.42 release.  I will try to find some time to look into it, but it's not a simple regression, something must have gone wrong in the bowls of 64-bitness.

-Eric
