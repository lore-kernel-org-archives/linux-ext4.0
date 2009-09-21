From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT3: filename duplicates
Date: Mon, 21 Sep 2009 11:52:23 -0500
Message-ID: <4AB7AF47.4070208@redhat.com>
References: <Pine.LNX.4.62.0906042111550.22287@tamago.serverit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Szabolcs Szakacsits <szaka@ntfs-3g.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZIUQwZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Sep 2009 12:52:25 -0400
In-Reply-To: <Pine.LNX.4.62.0906042111550.22287@tamago.serverit.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Szabolcs Szakacsits wrote:
> Hi,
> 
> When testing file creation performance we noticed that sometimes ext3 
> getdents64(2) lists some files twice. For instance after creating 
> filesnames from 1 to 1000000 in an empty directory:
> 
>  find | grep ./976253
>  ./976253
>  ./976253
> 
> This is 100% reproducible. Kernel is 2.6.25.5, x86_64.
> 
> Sorry if this was already known and fixed (couldn't find relevant info in 
> the archives, changelogs).

these 2 should have fixed it:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6a897cf447a83c9c3fd1b85a1e525c02d6eada7d
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8c9fa93d51123c5540762b1a9e1919d6f9c4af7c

-Eric

> Regards,
> 	   Szaka
> 
> --
> NTFS-3G: http://ntfs-3g.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

