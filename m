From: Lachlan McIlroy <lmcilroy@redhat.com>
Subject: Re: [PATCH V2] e2fsck: fix floating point precision error
Date: Wed, 30 Jun 2010 01:15:23 -0400 (EDT)
Message-ID: <830707684.485431277874923676.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
References: <1018916550.485351277874834611.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Lachlan McIlroy <lmcilroy@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:35576 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750869Ab0F3FPY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 01:15:24 -0400
In-Reply-To: <1018916550.485351277874834611.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix floating point precision error in e2fsck.

Commit 641b66bc7ee0a880b0eb0125dff5f8ed8dd5a160 fixed a floating
point precision error which can result in a search algorithm looping
forever.  It can also result in an array index being out of bounds
and causing a segfault.  Here are two more cases that need to be
fixed.  I've just used the same fix from the that commit.

Version 2: this time it's a patch against latest git, sorry for that.

Signed-off-by: Lachlan McIlroy <lmcilroy@redhat.com>


diff --git a/e2fsck/ea_refcount.c b/e2fsck/ea_refcount.c
index 39f2db7..b10cfff 100644
--- a/e2fsck/ea_refcount.c
+++ b/e2fsck/ea_refcount.c
@@ -196,9 +196,14 @@ retry:
 				range = 0;
 			else if (blk > highval)
 				range = 1;
-			else
+			else {
 				range = ((float) (blk - lowval)) /
 					(highval - lowval);
+				if (range > 0.9)
+					range = 0.9;
+				if (range < 0.1)
+					range = 0.1;
+			}
 			mid = low + ((int) (range * (high-low)));
 		}
 #endif
diff --git a/resize/extent.c b/resize/extent.c
index 0da8df6..94eb689 100644
--- a/resize/extent.c
+++ b/resize/extent.c
@@ -167,9 +167,14 @@ __u64 ext2fs_extent_translate(ext2_extent extent, __u64 old_loc)
 				range = 0;
 			else if (old_loc > highval)
 				range = 1;
-			else
+			else {
 				range = ((float) (old_loc - lowval)) /
 					(highval - lowval);
+				if (range > 0.9)
+					range = 0.9;
+				if (range < 0.1)
+					range = 0.1;
+			}
 			mid = low + ((__u64) (range * (high-low)));
 		}
 #endif

----- "Lachlan McIlroy" <lmcilroy@redhat.com> wrote:

> Fix floating point precision error in e2fsck.
> 
> Commit 641b66bc7ee0a880b0eb0125dff5f8ed8dd5a160 fixed a floating
> point precision error which can result in a search algorithm looping
> forever.  It can also result in an array index being out of bounds
> and causing a segfault.  Here are two more cases that need to be
> fixed.  I've just used the same fix from the that commit.
> 
> diff -up e2fsprogs-1.39/e2fsck/ea_refcount.c.orig
> e2fsprogs-1.39/e2fsck/ea_refcount.c
> --- e2fsprogs-1.39/e2fsck/ea_refcount.c.orig	2010-06-30
> 11:14:51.516239079 +1000
> +++ e2fsprogs-1.39/e2fsck/ea_refcount.c	2010-06-30 11:22:22.277362222
> +1000
> @@ -193,9 +193,14 @@ retry:
>  				range = 0;
>  			else if (blk > highval)
>  				range = 1;
> -			else 
> +			else {
>  				range = ((float) (blk - lowval)) /
>  					(highval - lowval);
> +				if (range > 0.9)
> +					range = 0.9;
> +				if (range < 0.1)
> +					range = 0.1;
> +			}
>  			mid = low + ((int) (range * (high-low)));
>  		}
>  #endif
> diff -up e2fsprogs-1.39/resize/extent.c.orig
> e2fsprogs-1.39/resize/extent.c
> --- e2fsprogs-1.39/resize/extent.c.orig	2010-06-30 11:25:58.969188333
> +1000
> +++ e2fsprogs-1.39/resize/extent.c	2010-06-30 11:26:40.449327216
> +1000
> @@ -167,9 +167,14 @@ __u32 ext2fs_extent_translate(ext2_exten
>  				range = 0;
>  			else if (old_loc > highval)
>  				range = 1;
> -			else 
> +			else {
>  				range = ((float) (old_loc - lowval)) /
>  					(highval - lowval);
> +				if (range > 0.9)
> +					range = 0.9;
> +				if (range < 0.1)
> +					range = 0.1;
> +			}
>  			mid = low + ((int) (range * (high-low)));
>  		}
>  #endif
> 
> Lachlan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
