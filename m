Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726946AbeK2Vne (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 16:43:34 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wATAcaXD036437
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2018 05:38:39 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2p2cswn0dy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2018 05:38:38 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 29 Nov 2018 10:38:33 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        ebiggers@kernel.org
Subject: Re: [f2fs-dev] [PATCH 2/7] f2fs: use IS_ENCRYPTED() to check encryption status
Date: Thu, 29 Nov 2018 16:08:31 +0530
In-Reply-To: <20181126173435.GA22888@thunk.org>
References: <20181119052324.31456-1-chandan@linux.vnet.ibm.com> <20181126040038.GD7904@thunk.org> <20181126173435.GA22888@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2911123.OYxvaggYeN@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday, November 26, 2018 11:04:35 PM IST Theodore Y. Ts'o wrote:
> On Sun, Nov 25, 2018 at 11:00:38PM -0500, Theodore Y. Ts'o wrote:
> > 
> > It might be that the simplest way to solve things is to merge the f2fs
> > dev branch up to 79c66e75720c.  This will have the net effect of
> > including the five patches listed above onto the fscrypt git tree.  So
> > long you don't plan to rebase or otherwise change these five patches,
> > it should avoid any merge conflicts.
> 
> I've set up a git branch which has the f2fs dev branch, 4.20-rc4, the
> fsverity patches, and part of Chandan's patch series here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/fscrypt.git test-working
> 
> There is a minor conflict when I did a trial merge with f2fs.git's dev
> branch, but it's pretty obvious to how to resolve it.
> 
> Jaegeuk, Eric, Chandan, please take a look and let me know what you
> think.

Ted,

I have addressed the review comments provided by Eric. Hence three out of
the four patches in the test-working branch have new changes. I also got
UBIFS to use CONFIG_FS_ENCRYPTION instead of the per-filesystem config
symbol.

I am currently executing fstests to verify the changes.


Eric,

When executing generic/900, I noticed that sometimes xfs_io would get stuck
for an indefinite period. /proc/<pid of xfs_io>/stack showed that the task was
stuck in tty_read() inside the kernel. The following change fixed it,

diff --git a/tests/generic/900 b/tests/generic/900
index 290889ce..0831eed4 100755
--- a/tests/generic/900
+++ b/tests/generic/900
@@ -83,7 +83,7 @@ _fsv_create_enable_file $fsv_file >> $seqres.full
 echo "* reading"
 $XFS_IO_PROG -r $fsv_file -c ''
 echo "* xfs_io writing, should be O_RDWR"
-$XFS_IO_PROG $fsv_file |& _filter_scratch
+$XFS_IO_PROG -c '' $fsv_file 2>&1 | _filter_scratch
 echo "* bash >>, should be O_APPEND"
 bash -c "echo >> $fsv_file" |& _filter_scratch
 echo "* bash >, should be O_WRONLY|O_CREAT|O_TRUNC"

xfs_io gets into interactive mode when invoked without a "-c cmd" string.

However, I am not able recreate the scenario once again without the above
changes applied. I am not sure about what changed. 

-- 
chandan
