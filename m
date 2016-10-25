From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [BUG] softlockup observed with 64k block size on ppc64
Date: Tue, 25 Oct 2016 18:49:54 +0530
Message-ID: <17387849.5EiRHCrpou@localhost.localdomain>
References: <369354227.RU6GsvOxus@localhost.localdomain> <20161025081319.GC16260@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935062AbcJYNUD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Oct 2016 09:20:03 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9PDF9dr006344
        for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2016 09:20:03 -0400
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26a7gcjjsm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2016 09:20:02 -0400
Received: from localhost
        by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 25 Oct 2016 23:20:00 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id 9EA3A3578053
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2016 00:19:57 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
        by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u9PDJvh561210826
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2016 00:19:57 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
        by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u9PDJvZR021925
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2016 00:19:57 +1100
In-Reply-To: <20161025081319.GC16260@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday, October 25, 2016 10:13:19 AM Jan Kara wrote:
> Hi!
> 
> On Mon 24-10-16 14:10:02, Chandan Rajendra wrote:
> > The following soft lockup occurs when fstests' ext4/303 test is executed with
> > 64k block size on a ppc64 machine running linux-4.8 kernel.
> 
> Thanks for report! I had a look into the code and I'm not sure why this
> happens. Is this reproducible? Did it happen also with older kernels?

Yes, This issue can be recreated every single time the test is executed. The
bug is present atleast from linux-v4.0 version. I haven't verified if the bug
is present in earlier versions of the kernel.

-- 
chandan

