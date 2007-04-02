From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Add i_version_hi for 64-bit version
Date: Mon, 02 Apr 2007 14:47:38 -0700
Message-ID: <1175550458.4333.13.camel@localhost.localdomain>
References: <1174212819.3282.10.camel@garfield>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	TheodoreTso <tytso@mit.edu>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:42745 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965976AbXDBVrl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2007 17:47:41 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l32LlfXP009706
	for <linux-ext4@vger.kernel.org>; Mon, 2 Apr 2007 17:47:41 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l32LlesE197184
	for <linux-ext4@vger.kernel.org>; Mon, 2 Apr 2007 15:47:40 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l32LldCw019281
	for <linux-ext4@vger.kernel.org>; Mon, 2 Apr 2007 15:47:40 -0600
In-Reply-To: <1174212819.3282.10.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2007-03-18 at 15:43 +0530, Kalpak Shah wrote:
> Hi,
> 
> This patch adds a 32-bit i_version_hi field to ext4_inode, which can be used for 64-bit inode versions. This field will store the higher 32 bits of the version, while Jean Noel's patch has added support to store the lower 32-bits in osd1.linux1.l_i_version.
> 
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> 
> Index: linux-2.6.20/include/linux/ext4_fs.h
> ===================================================================
> --- linux-2.6.20.orig/include/linux/ext4_fs.h
> +++ linux-2.6.20/include/linux/ext4_fs.h
> @@ -336,6 +336,7 @@ struct ext4_inode {
>         __le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
>         __le32  i_crtime;       /* File Creation time */
>         __le32  i_crtime_extra; /* extra File Creation time (nsec << 2 | epoch) */
> +       __u32   i_version_hi;   /* high 32 bits for 64-bit version */
>  };
> 

Any reason not using __le32 for the i_version_hi?


Thanks,
Mingming
