From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2fs: fix endian checking bits
Date: Tue, 04 Nov 2014 17:35:15 -0600
Message-ID: <545962B3.80003@redhat.com>
References: <20141104232911.GC10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaKDXfV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 18:35:21 -0500
In-Reply-To: <20141104232911.GC10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/4/14 5:29 PM, Darrick J. Wong wrote:
> Commit 3e683eef936e6d ("define bitwise types and annotate conversion
> routines") broke the build on various platforms.  Turns out that
> crossing our fingers wasn't such a good idea, so just define it
> separately.

sooorrry!

Seems fine, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/blkid/blkid_types.h.in |   15 ---------------
>  lib/ext2fs/ext2_types.h.in |    8 +++++++-
>  2 files changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/lib/blkid/blkid_types.h.in b/lib/blkid/blkid_types.h.in
> index 2bb3d85..d4c81d0 100644
> --- a/lib/blkid/blkid_types.h.in
> +++ b/lib/blkid/blkid_types.h.in
> @@ -164,19 +164,4 @@ typedef long		__s64;
>  #undef __S64_TYPEDEF
>  #undef __U64_TYPEDEF
>  
> -#ifdef __CHECKER__
> -#define __bitwise		__attribute__((bitwise))
> -#define __force			__attribute__((force))
> -#else
> -#define __bitwise
> -#define __force
> -#endif
> -
> -typedef __u16	__bitwise	__le16;
> -typedef __u32	__bitwise	__le32;
> -typedef __u64	__bitwise	__le64;
> -typedef __u16	__bitwise	__be16;
> -typedef __u32	__bitwise	__be32;
> -typedef __u64	__bitwise	__be64;
> -
>  #endif /* _*_TYPES_H */
> diff --git a/lib/ext2fs/ext2_types.h.in b/lib/ext2fs/ext2_types.h.in
> index a00ed7f..fd57231 100644
> --- a/lib/ext2fs/ext2_types.h.in
> +++ b/lib/ext2fs/ext2_types.h.in
> @@ -164,6 +164,12 @@ typedef long		__s64;
>  #undef __S64_TYPEDEF
>  #undef __U64_TYPEDEF
>  
> +#endif /* _*_TYPES_H */
> +
> +/* endian checking stuff */
> +#ifndef EXT2_ENDIAN_H_
> +#define EXT2_ENDIAN_H_
> +
>  #ifdef __CHECKER__
>  #define __bitwise		__attribute__((bitwise))
>  #define __force			__attribute__((force))
> @@ -179,6 +185,6 @@ typedef __u16	__bitwise	__be16;
>  typedef __u32	__bitwise	__be32;
>  typedef __u64	__bitwise	__be64;
>  
> -#endif /* _*_TYPES_H */
> +#endif /* EXT2_ENDIAN_H_ */
>  
>  @PUBLIC_CONFIG_HEADER@
> 

