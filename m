Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43526 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728149AbeK0OAR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 09:00:17 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAR33TZh040818
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2018 22:03:55 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2p0su87vhs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2018 22:03:54 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 27 Nov 2018 03:03:53 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, ebiggers@kernel.org
Subject: Re: [PATCH 5/7] ext4: use IS_VERITY() to check inode's fsverity status
Date: Tue, 27 Nov 2018 08:33:52 +0530
In-Reply-To: <20181126173615.GB22888@thunk.org>
References: <20181119052324.31456-1-chandan@linux.vnet.ibm.com> <20181119052324.31456-6-chandan@linux.vnet.ibm.com> <20181126173615.GB22888@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1994749.6ROMBDTyAZ@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday, November 26, 2018 11:06:15 PM IST Theodore Y. Ts'o wrote:
> On Mon, Nov 19, 2018 at 10:53:22AM +0530, Chandan Rajendra wrote:
> > This commit now uses IS_VERITY() macro to check if fsverity is
> > enabled on an inode.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> This patch causes a massive number of fsverity tests.  I suspect it's
> due to a mismatch between the ext4's inode flags as opposed to the VFS
> inode's flags.  I'll take a closer look in the next day or two.
> 

I will check this and report back soon. 

-- 
chandan
