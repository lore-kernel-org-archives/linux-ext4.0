From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 2/3] ext4 online defrag (ver 0.7)
Date: Wed, 19 Mar 2008 10:40:59 +0900
Message-ID: <200803190140.AA00340@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:39523 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936347AbYCSVJq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 17:09:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Solofo,
> Hello,
>
> Akira Fujita writes:
>  > -			printk(KERN_ERR "defrag: failed ext4_ext_defrag\n");
>  > -			goto ERR;
>  > +			printk(KERN_ERR "ext4 defrag: "
>  > +				"Moving victim file failed. ino [%lu]\n",
>  > +				ext_info->ino);
>
> This triggers this warning:
> fs/ext4/defrag.c: In function 'ext4_defrag_move_victim':
> fs/ext4/defrag.c:458: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'long long unsigned int'
>
> (ext4-online-defrag-free-space-fragmentation.patch from ext4-patch-queue 36c86f09d6ac97c2797a1a94d76e2fc1dc3b03f8)
>
Thank you for notification.
And sorry for the delay fix, it has already been pointed out by Mingming.

Regards Akira, 

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
--- linux-2.6.25-rc5-ext4-org/fs/ext4/defrag.c  2008-03-19 07:16:40.000000000 +0900
+++ linux-2.6.25-rc5-full/fs/ext4/defrag.c      2008-03-19 08:31:01.000000000 +0900
@@ -454,7 +454,7 @@ static int ext4_defrag_move_victim(struc
                        ext_info->ext[i].len, goal, DEFRAG_FORCE_VICTIM, &ext);
                if (ret < 0) {
                        printk(KERN_ERR "ext4 defrag: "
-                               "Moving victim file failed. ino [%lu]\n",
+                               "Moving victim file failed. ino [%llu]\n",
                                ext_info->ino);
                        goto err;
                }
