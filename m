From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Tue, 03 Jul 2007 16:11:15 +0530
Message-ID: <1183459275.4102.6.camel@garfield.linsyssoft.com>
References: <1183275416.4010.125.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1183275416.4010.125.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2007-07-01 at 03:36 -0400, Mingming Cao wrote:
> +
> +#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)                               \
> +do {                                                                        \
> +     (inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);               \
> +     if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
> +             ext4_decode_extra_time(&(inode)->xtime,                        \
> +                                    raw_inode->xtime ## _extra);            \
> +} while (0)
> +
> +#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)                             \
> +do {                                                                        \
> +     if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))                      \
> +             (einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
> +     if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))            \
> +             ext4_decode_extra_time(&(einode)->xtime,                       \
> +                                    raw_inode->xtime ## _extra);            \
> +} while (0)
> +

This nanosecond patch seems to be missing the fix below which is required for http://bugzilla.kernel.org/show_bug.cgi?id=5079

If the timestamp is set to before epoch i.e. a negative timestamp then the file may have its date set into the future on 64-bit systems. So when the timestamp is read it must be cast as signed.

Index: linux-2.6.21/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/ext4_fs.h
+++ linux-2.6.21/include/linux/ext4_fs.h
@@ -390,7 +390,7 @@ do {                                                                               \

 #define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)                         \
 do {                                                                          \
-       (inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);               \
+       (inode)->xtime.tv_sec = (signed)le32_to_cpu((raw_inode)->xtime);       \
        if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
                ext4_decode_extra_time(&(inode)->xtime,                        \
                                       raw_inode->xtime ## _extra);            \
@@ -399,7 +399,8 @@ do {                                                                               \
 #define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)                               \
 do {                                                                          \
        if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))                      \
-               (einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
+               (einode)->xtime.tv_sec =                                       \
+                               (signed)le32_to_cpu((raw_inode)->xtime);       \
        if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))            \
                ext4_decode_extra_time(&(einode)->xtime,                       \
                                       raw_inode->xtime ## _extra);            \


Thanks,
Kalpak.


