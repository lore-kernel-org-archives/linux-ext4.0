From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 4][PATCH 2/5] i_version: Add hi 32 bit inode version
 on ext4 on-disk inode
Date: Tue, 10 Jul 2007 16:30:47 -0700
Message-ID: <20070710163047.1aba94f9.akpm@linux-foundation.org>
References: <1183275436.4010.127.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1183275436.4010.127.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:37:16 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> This patch adds a 32-bit i_version_hi field to ext4_inode, which can be used for 64-bit inode versions. This field will store the higher 32 bits of the version, while Jean Noel's patch has added support to store the lower 32-bits in osd1.linux1.l_i_version.

Please wordwrap this changelog entry to less than 80 columns.  Well, less
than 258, anyway ;)

> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> ---
> Index: linux-2.6.21/include/linux/ext4_fs.h
> ===================================================================
> --- linux-2.6.21.orig/include/linux/ext4_fs.h
> +++ linux-2.6.21/include/linux/ext4_fs.h
> @@ -342,6 +342,7 @@ struct ext4_inode {
>  	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
>  	__le32  i_crtime;       /* File Creation time */
>  	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
> +	__le32	i_version_hi;	/* high 32 bits for 64-bit version */
>  };

Aren't there forward- backward-compatibility issues here?  How does the
filesystem driver work out whether this field is present and valid?

The changelog should describe this design issue.
