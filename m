From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] Add i_version_hi for 64-bit version
Date: Mon, 19 Mar 2007 10:34:36 -0500
Message-ID: <1174318476.11636.1.camel@kleikamp.austin.ibm.com>
References: <1174212819.3282.10.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	TheodoreTso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45774 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbXCSPf4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2007 11:35:56 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2JFZsOw012484
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 11:35:54 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2JFYc61224748
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 11:34:38 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2JFYbj4022163
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 11:34:38 -0400
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

This is whitespace damaged.  I see spaces instead of tabs.

> 
>  #define i_size_high    i_dir_acl
> 
> Thanks,
> Kalpak <kalpak@clusterfs.com>

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
