From: Niu Yawei <yawei.niu@gmail.com>
Subject: Re: [PATCH] tune2fs: update i_size in ext2fs_file_write()
Date: Tue, 08 Oct 2013 11:30:10 +0800
Message-ID: <52537C42.9010808@gmail.com>
References: <5231CDFE.8050206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, yawei.niu@intel.com,
	andreas.dilger@intel.com
To: adityakali@google.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38035 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3JHDaX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Oct 2013 23:30:23 -0400
Received: by mail-pa0-f47.google.com with SMTP id kp14so8167255pab.6
        for <linux-ext4@vger.kernel.org>; Mon, 07 Oct 2013 20:30:22 -0700 (PDT)
In-Reply-To: <5231CDFE.8050206@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_file_write() needs to update i_size on successful write,
otherwise, ext2fs_file_read() in same open/close cycle will not
be able to read the just written data.

This bug result in the the problem of quotacheck triggered on
'tune2fs -O quota' failed to write back multiple users/groups
accounting information.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
---
 lib/ext2fs/fileio.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 1f7002c..e395eb6 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -307,6 +307,15 @@ errcode_t ext2fs_file_write(ext2_file_t file, const
void *buf,
 	}

 fail:
+	/* Update inode size */
+	if (count != 0 && EXT2_I_SIZE(&file->inode) < file->pos) {
+		errcode_t	rc;
+
+		rc = ext2fs_file_set_size2(file, file->pos);
+		if (retval == 0)
+			retval = rc;
+	}
+
 	if (written)
 		*written = count;
 	return retval;
-- 
1.7.1

> ext2fs_file_write() needs to update i_size on successful write,
> otherwise, ext2fs_file_read() in same open/close cycle will not
> be able to read the just written data.
> 
> Which result in the the problem of quotacheck triggered on
> 'tune2fs -O quota' failed to write back multiple users/groups
> accounting information.
> 
> Signed-off-by: Niu Yawei <yawei.niu@intel.com>
> ---
>  lib/ext2fs/fileio.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
> index 1f7002c..b1b5540 100644
> --- a/lib/ext2fs/fileio.c
> +++ b/lib/ext2fs/fileio.c
> @@ -304,6 +304,13 @@ errcode_t ext2fs_file_write(ext2_file_t file, const
> void *buf,
>  		ptr += c;
>  		count += c;
>  		nbytes -= c;
> +
> +		/* Update inode size */
> +		if (EXT2_I_SIZE(&file->inode) < file->pos) {
> +			retval = ext2fs_file_set_size2(file, file->pos);
> +			if (retval)
> +				goto fail;
> +		}
>  	}
> 
>  fail:
> 

