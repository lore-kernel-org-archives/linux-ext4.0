From: Paul Paulson <paul.paulson@seagate.com>
Subject: Re: [PATCH] generic/017: skip tests with mkfs failures
Date: Tue, 7 Oct 2014 13:12:51 -0500
Message-ID: <CAG4SSaSQt15AOOVR50EruW8sq_9Az3W26z+7pHy-2E9D3gOcgg@mail.gmail.com>
References: <1412619830-23088-1-git-send-email-paul.paulson@seagate.com>
	<20141007005300.GA11741@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:15631 "EHLO
	mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbaJGSMx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2014 14:12:53 -0400
Received: from pps.filterd (m0075553.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.14.5/8.14.5) with SMTP id s97I41AK027995
	for <linux-ext4@vger.kernel.org>; Tue, 7 Oct 2014 14:12:53 -0400
Received: from mail-qc0-f181.google.com (mail-qc0-f181.google.com [209.85.216.181])
	by mx0a-00003501.pphosted.com with ESMTP id 1pvm7kramj-1
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 07 Oct 2014 14:12:52 -0400
Received: by mail-qc0-f181.google.com with SMTP id r5so6315045qcx.12
        for <linux-ext4@vger.kernel.org>; Tue, 07 Oct 2014 11:12:51 -0700 (PDT)
In-Reply-To: <20141007005300.GA11741@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 6, 2014 at 7:53 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Mon, Oct 06, 2014 at 01:23:50PM -0500, Paul Paulson wrote:
> > The mkfs command fails to create ext4 filesystems on partition sizes
> > greater than 1998080 MiB when using 1024 byte blocks and the default
> > calculation for the number of inodes reserved for the filesystem.
>
> I've never noticed a problem because creating a partition that large
> makes the xfstests runs take a long, long time.  I typically use a 5
> GB or 20GB partition.  Is there a particular reason why you are trying
> to do test ext4 using a 1k blocksize for a 2T file system?  We can fix
> mke2fs so it doesn't fail when you create a > 2T file system with a 1k
> block size, but the bigger question in my mind is why anyone would
> ever want to do that?
>
>                                         - Ted
We'd like to run the full test suite using maximum partition sizes on
SMR drives for functional and performance evaluation purposes. Since
drive capacities are increasing so rapidly it would be nice if mke2fs
would support filesystems up to the maximum configurations specified
in the Ext4_Disk_Layout document using default filesystem configs. For
example, the 127877120 inode limit that we ran into is only 3% of the
number of inodes specified in the document (2^32 inodes in a 4 TiB
filesystem with 1KiB block sizes for 32-bit mode).
