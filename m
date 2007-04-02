From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] Add i_version_hi for 64-bit version
Date: Mon, 2 Apr 2007 17:29:23 -0600
Message-ID: <20070402232923.GU5967@schatzie.adilger.int>
References: <1174212819.3282.10.camel@garfield> <1175550458.4333.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:58308 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966065AbXDBX3Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2007 19:29:25 -0400
Content-Disposition: inline
In-Reply-To: <1175550458.4333.13.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 02, 2007  14:47 -0700, Mingming Cao wrote:
> On Sun, 2007-03-18 at 15:43 +0530, Kalpak Shah wrote:
> > This patch adds a 32-bit i_version_hi field to ext4_inode, which can be used for 64-bit inode versions. This field will store the higher 32 bits of the version, while Jean Noel's patch has added support to store the lower 32-bits in osd1.linux1.l_i_version.
> > 
> > Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> > Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> > 
> > Index: linux-2.6.20/include/linux/ext4_fs.h
> > ===================================================================
> > --- linux-2.6.20.orig/include/linux/ext4_fs.h
> > +++ linux-2.6.20/include/linux/ext4_fs.h
> > @@ -336,6 +336,7 @@ struct ext4_inode {
> >         __le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
> >         __le32  i_crtime;       /* File Creation time */
> >         __le32  i_crtime_extra; /* extra File Creation time (nsec << 2 | epoch) */
> > +       __u32   i_version_hi;   /* high 32 bits for 64-bit version */
> >  };
> > 
> 
> Any reason not using __le32 for the i_version_hi?

Not really.  I've also asked Kalpak to run sparse with Shaggy's flags
against the other patches to fix up any similar issues.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
