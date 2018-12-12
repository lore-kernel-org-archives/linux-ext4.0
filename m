Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726237AbeLLEQZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 23:16:25 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBC4F0eJ034225
        for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2018 23:16:24 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2paqh479su-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2018 23:16:24 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 12 Dec 2018 04:16:21 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: Regression in next-20181211 with fsverity changes
Date: Wed, 12 Dec 2018 09:46:27 +0530
In-Reply-To: <20181211191220.GW6707@atomide.com>
References: <20181211191220.GW6707@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <3171217.2PqYythArb@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday, December 12, 2018 12:42:20 AM IST Tony Lindgren wrote:
> Hi,
> 
> Looks like commit 4de97efb578a ("fsverity: Move verity status check
> to fsverity_file_open") causes a boot regression for me with root
> on ext4 SDIO card, see below.
> 

fsverity_file_open() used to incorrectly return -EOPNOTSUPP for non-fsverity
files on kernels built without fsverity support. This bug has been fixed in
the V4 patchset <https://marc.info/?l=linux-ext4&m=154458767124953&w=2>.

-- 
chandan
