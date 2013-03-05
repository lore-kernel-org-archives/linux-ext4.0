From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH] xfstests: use native definition of O_DIRECT flag
Date: Tue, 5 Mar 2013 14:09:22 -0600
Message-ID: <513650F2.8060406@sgi.com>
References: <20130226210322.GB5275@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <xfs@oss.sgi.com>, <linux-ext4@vger.kernel.org>
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:56342 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753309Ab3CEUJe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Mar 2013 15:09:34 -0500
In-Reply-To: <20130226210322.GB5275@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch has been committed.

Thanks
--Rich

commit 5825ecd3b99ed8c177895d5e6a830133fed384ea
Author: Eric Whitney <enwlinux@gmail.com>
Date:   Tue Feb 26 21:03:22 2013 +0000

     xfstests: use native definition of O_DIRECT flag

     The definition of O_DIRECT in src/trunc.c causes xfstest 125 to fail
     when run on a Pandaboard.  On ARM, the value used (0x040000) is
     O_DIRECTORY rather than O_DIRECT as it is on x86.  Prefer the 
platform's
     native definition of O_DIRECT supplied by fcntl.h if available.  Also,
     fix a couple of error messages to properly reflect their context.

     Signed-off-by: Eric Whitney <enwlinux@gmail.com>
     Reviewed-by: Dave Chinner <dchinner@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>
