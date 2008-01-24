From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: ext4-online-defrag-free-space-fragmentation.patch uses do_fsync()
Date: Thu, 24 Jan 2008 12:00:46 +0900
Message-ID: <00ae01c85e35$51c4f8c0$41a8400a@bsd.tnes.nec.co.jp>
References: <E1JHg4T-0007lQ-8f@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>,
	"Akira Fujita" <a-fujita@rs.jp.nec.com>,
	"Mingming Cao" <cmm@us.ibm.com>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:49361 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYAXDB4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2008 22:01:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> I was trying to build ext4 as a module, and ran into problems because
> the online defrag patch is calling do_fsync() which is *not* an exported
> symbol, and so can not be called from a module.
> 
> Looking at what the routine is doing, there's no reason to call
> do_fsync(), and in fact depending on the journaling mode in use, it may
> not force a journal commit, which seems to be the goal of the code.
> 
> Hence, I plan to merge the following fix into the the
> defrag-free-space-fragmentation patch, unless there are any objections
> from Takashi-San or Akira-San.

Thank you for your information and the proposition of the fix.
Your fix is correct, please merge it.

> Regards,
> 
> - Ted
> 
> diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
> index 4ef3dc0..19d2cfd 100644
> --- a/fs/ext4/defrag.c
> +++ b/fs/ext4/defrag.c
> @@ -632,8 +632,9 @@ static int ext4_ext_defrag_victim(struct file *target_filp,
>  }
> 
>  /* Sync journal blocks before reservation */
> - if (do_fsync(target_filp, 0)) {
> - printk(KERN_ERR "defrag: failed do_fsync\n");
> + ret = ext4_force_commit(sb);
> + if (ret) {
> + printk(KERN_ERR "defrag: failed do_fsync (%d)\n", ret);
>  goto ERR;
>  }
>  }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Takashi
