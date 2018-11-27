Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60278 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727292AbeK1A32 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 19:29:28 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wARDOK6h064309
        for <linux-ext4@vger.kernel.org>; Tue, 27 Nov 2018 08:31:31 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2p15q135y3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Tue, 27 Nov 2018 08:31:31 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 27 Nov 2018 13:31:29 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu
Subject: Re: [PATCH 7/7] fsverity: Remove filesystem specific build config option
Date: Tue, 27 Nov 2018 19:01:28 +0530
In-Reply-To: <20181127004530.GF11663@gmail.com>
References: <20181119052324.31456-1-chandan@linux.vnet.ibm.com> <20181119052324.31456-8-chandan@linux.vnet.ibm.com> <20181127004530.GF11663@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2413763.K7ZbsYlPLa@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday, November 27, 2018 6:15:30 AM IST Eric Biggers wrote:
> Hi Chandan,
> 
> On Mon, Nov 19, 2018 at 10:53:24AM +0530, Chandan Rajendra wrote:
> > In order to have a common code base for fsverity "post read" processing
> > for all filesystems which support per-file verity, this commit removes
> > filesystem specific build config option (e.g. CONFIG_EXT4_FS_VERITY) and
> > replaces it with a build option (i.e. CONFIG_FS_VERITY) whose value
> > affects all the filesystems making use of fsverity.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> Like the corresponding fscrypt patch, this is missing changing
> 
> #if IS_ENABLED(CONFIG_FS_VERITY)
> 
> in include/linux/fs.h to
> 
> #ifdef CONFIG_FS_VERITY
> 
> There are also references to the filesystem-specific config options in
> Documentation/filesystems/fsverity.rst that need to be updated.
> 
> I also suggest updating the Kconfig help text for CONFIG_FS_VERITY and
> CONFIG_FS_ENCRYPTION to mention the supported filesystems, similar to how
> CONFIG_QUOTA lists the filesystems it supports.
> 

I will fix this one too.

-- 
chandan
