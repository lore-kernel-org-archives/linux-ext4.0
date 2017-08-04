From: Carlos Eduardo Maiolino <cmaiolin@redhat.com>
Subject: Re: How to install set_encpolicy for xfs_io
Date: Fri, 4 Aug 2017 04:49:51 -0400 (EDT)
Message-ID: <455107637.66214831.1501836591708.JavaMail.zimbra@redhat.com>
References: <20170802084855.52xnbunchkggipbz@linux> <20170802112558.bogzbht7n7dlfpzk@hades.localdomain> <20170803013433.qki2jn7jg3j4fjcs@hqi2-mobl3.ccr.corp.intel.com> <c2c93913-9d4e-8a50-f7d3-1c88db7595f2@gmail.com> <20170804081717.6iqnus5tgcbodikq@haikuoyu-mobl4.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>,
        linux-ext4@vger.kernel.org
To: Dai Xiang <xiangx.dai@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751303AbdHDItx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 4 Aug 2017 04:49:53 -0400
In-Reply-To: <20170804081717.6iqnus5tgcbodikq@haikuoyu-mobl4.ccr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> > SGI have essentially abandoned all xfs-related infrastructure hosting.
> > As a result the mailing list got moved to kernel.org infrastructure and
> > the development branches as well. I'd suggest to always use the xfs
> > repos hosted on git.kernel.org
> 
> Hi, i do install as below and cp /xfsprogs to other host, i still can
> not get set_encpolicy:
> 
> 	make configure || return
> 	./configure --prefix=/xfsprogs/usr --exec_prefix=/xfsprogs/usr
> 	make || return
> 	make install
> 	make install-dev
> 
> I git clone newest codes and HEAD is:
> commit 0602fbe880e59c3aff13a081632b79532a40a328 (HEAD -> master, tag:
> v4.12.0, origin/master, origin/HEAD)
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Thu Jul 20 10:57:14 2017 -0500
> 
>     xfsprogs: Release v4.12.0
>     
>     Update all the necessary files for a 4.12.0 release.
>     
>     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Do i miss something important?
> 
> Thanks
> Xiang
> 

No, 4.12 already has it, you are doing something else, can you run 'xfs_io -V'
and confirm you are using a xfsprogs >= 4.10?

you didn't install int in the usual prefix, so, it is likely you don't have it in your $PATH
and you are triggering an old xfsprogs version.

-- 
--Carlos
