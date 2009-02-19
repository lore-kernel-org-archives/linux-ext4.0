From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V5 1/5] quota: Add reservation support for delayed	block allocation
Date: Thu, 19 Feb 2009 15:15:06 +0100
Message-ID: <20090219141505.GA15068@atrey.karlin.mff.cuni.cz>
References: <1231216808.9267.22.camel@mingming-laptop> <20090106100645.GH10705@duck.suse.cz> <1231805946.6752.17.camel@mingming-laptop> <20090113153748.GE10064@duck.suse.cz> <1231872797.8719.6.camel@mingming-laptop> <20090113190931.GI10064@duck.suse.cz> <1231893775.8719.22.camel@mingming-laptop> <4987EE04.4020506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Gui Xiaohua <guixh@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40437 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZBSOPI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Feb 2009 09:15:08 -0500
Content-Disposition: inline
In-Reply-To: <4987EE04.4020506@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> I have tested your patch in 2.6.29-rc1. The sum of characters which 
> i had written were fewer than the block softlimit,but a warning occurs.
  I haven't seen any reply to this. Did it get resolved?

> # edquota -u quser1
> Disk quotas for user quser1 (uid 504):
>   Filesystem                   blocks       soft       hard     inodes     soft     hard
>   /dev/sda7                         0          5         10          0        5       10
> 
> Steps to reproduce:
> 
> # mkfs.ext4 /dev/sda7
> # mount /dev/sda7 /mnt -t ext4
> # setquota -u quser1 5 10 5 10 /mnt
> 
> Then log in as quser1
> $ cd /mnt
> $ ll
> total 20
> -rw------- 1 root root  7168 01-20 01:51 aquota.user
> drwx------ 2 root root 12288 01-20 01:44 lost+found
> $ vim dd.sh
  Well, vim creates backup files and possibly some other stuff so it's
quite possible that the block limit of 10 KB has been exceeded. Could
you verify that e.g.: echo "abc" >dd.sh
works as expected (you should then see 4KB used).

> I written some characters,such as abc,then i do wq,
> the warning occurs likes below:
> "dd.sh" sda7: write failed, user block limit reached.

									Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
