From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [BUG] ext4 timestamps corruption
Date: Thu, 23 Jun 2011 16:52:24 +0900
Message-ID: <4E02F0B8.4080301@rs.jp.nec.com>
References: <4DF1D57C.3030107@rs.jp.nec.com> <3BB3CFE7-BD50-4123-A1C8-D3FDAAD184DA@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64160 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab1FWHwy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 03:52:54 -0400
In-Reply-To: <3BB3CFE7-BD50-4123-A1C8-D3FDAAD184DA@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Thanks for comment. I wrote a patch, could you review this?

(2011/06/12 1:48), Andreas Dilger wrote:
> 
> On 2011-06-10, at 2:27 AM, Akira Fujita <a-fujita@rs.jp.nec.com <mailto:a-fujita@rs.jp.nec.com>> wrote:
>>
>> Officially, ext4 can handle its timestamps until 2514
>> with 32bit entries plus EPOCH_BIT (2bits).
>> But when timestamps values use 32+ bit
>> (e.g. 2038-01-19 9:14:08 0x0000000080000000),
>> we can get corrupted values.
>> Because sign bit is overwritten by transferring value
>> between kernel space and user space.
>>
>> This can be happened with kernel 3.0.0-rc2 (Also older kernel)
>> on x86_64.
>>
>> # This issue is already on Bugzilla,
>> does anybody know this current status?
>> https://bugzilla.kernel.org/show_bug.cgi?id=23732
> 
> I can't find any discussion about this bug in the list archives, but it is definitely a real problem.
> 
> At first glance, it appears that the correct solution is to shift the high bits in the extra time by only 31 bits.
> 
> As stated in the posting, it makes sense to keep the range -2^31 - +2^33 for maximum usability. I don't think there is any value to store more negative times.
> 
> To be honest I also don't think there is any value to even keeping negative timestamps (before 1970) since this is about storing file creation/modification times and I don't think any files with real 
> creation dates before 1970 are used anywhere.
> 
> Either way I expect the time range to be sufficient, once the bug is fixed.

ext4: Fix ext4 timestamps corruption

Officially, ext4 can handle its timestamps until 2514
with 32bit entries plus EPOCH_BIT (2bits).
But when timestamps values use 32+ bit
(e.g. 2038-01-19 9:14:08 0x0000000080000000),
we can get corrupted values.
Because sign bit is overwritten by transferring value
between kernel space and user space.

To fix this issue, 32th bit of extra time fields in ext4_inode structure
(e.g. i_ctime_extra) are used as the sign for 64bit user space.
Because these are used only 20bits for nano-second and bottom of 2bits
are for EXT4_EPOCH_BITS shift.
With this patch, ext4 supports timestamps Y1901-2514.

The performance comparison is as follows:
------------------------------------------------
|              | file create   |   ls -l       |
|--------------|---------------|----------------
|with patch    | 138.2056 sec  | 14.9333 sec   |
|without patch | 133.4566 sec  | 14.9096 sec   |
------------------------------------------------
 file count:1 million (average of 3 trials)
 kernel: 3.0.0-rc3

There is a slightly difference, but I think it is acceptable.

Thanks and Regards,
Akira Fujita

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/ext4.h |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff -Nrup -X linux-3.0-rc3-a/Documentation/dontdiff linux-3.0-rc3-a/fs/ext4/ext4.h linux-3.0-rc3-b/fs/ext4/ext4.h
--- linux-3.0-rc3-a/fs/ext4/ext4.h	2011-06-14 07:29:59.000000000 +0900
+++ linux-3.0-rc3-b/fs/ext4/ext4.h	2011-06-23 14:18:47.000000000 +0900
@@ -645,6 +645,7 @@ struct move_extent {
 #define EXT4_EPOCH_BITS 2
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
 #define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
+#define EXT4_TIMESTAMP_SIGN_MASK 0x80000000

 /*
  * Extended fields will fit into an inode if the filesystem was formatted
@@ -665,16 +666,23 @@ struct move_extent {
 static inline __le32 ext4_encode_extra_time(struct timespec *time)
 {
        return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
-			   (time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
-                          ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
+		(time->tv_sec >> 32) &
+		(EXT4_EPOCH_MASK | EXT4_TIMESTAMP_SIGN_MASK) :
+		time->tv_sec & EXT4_TIMESTAMP_SIGN_MASK) |
+		((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
 }

 static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
 {
-       if (sizeof(time->tv_sec) > 4)
+	if (sizeof(time->tv_sec) > 4) {
 	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
 			       << 32;
-       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
+		if (le32_to_cpu(extra) & EXT4_TIMESTAMP_SIGN_MASK)
+			time->tv_sec |= EXT4_NSEC_MASK << 32;
+	}
+
+	time->tv_nsec = ((le32_to_cpu(extra) & ~EXT4_TIMESTAMP_SIGN_MASK) >>
+				EXT4_EPOCH_BITS);
 }

 #define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)			       \
@@ -696,19 +704,23 @@ do {									       \

 #define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)			       \
 do {									       \
-	(inode)->xtime.tv_sec = (signed)le32_to_cpu((raw_inode)->xtime);       \
-	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
+	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra)) {   \
+		(inode)->xtime.tv_sec =                                        \
+				(__u32)(le32_to_cpu((raw_inode)->xtime));      \
 		ext4_decode_extra_time(&(inode)->xtime,			       \
 				       raw_inode->xtime ## _extra);	       \
-	else								       \
+	} else {							       \
+		(inode)->xtime.tv_sec =                                        \
+			(signed)le32_to_cpu((raw_inode)->xtime);               \
 		(inode)->xtime.tv_nsec = 0;				       \
+	}                                                                      \
 } while (0)

 #define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)			       \
 do {									       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
-		(einode)->xtime.tv_sec = 				       \
-			(signed)le32_to_cpu((raw_inode)->xtime);	       \
+		(einode)->xtime.tv_sec =                                       \
+			(__u32)(le32_to_cpu((raw_inode)->xtime));              \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
 		ext4_decode_extra_time(&(einode)->xtime,		       \
 				       raw_inode->xtime ## _extra);	       \
