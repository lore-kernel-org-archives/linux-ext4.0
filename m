From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 20:48:11 +0800
Message-ID: <20120418124811.GD3447@gmail.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
 <4F8DAAFE.40500@redhat.com>
 <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com>
 <alpine.LFD.2.00.1204181015050.5310@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37492 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2DRMlo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Apr 2012 08:41:44 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1204181015050.5310@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I run a more detailed benchmark again.  The environment is as before,
and the machine has Intel(R) Core(TM)2 Duo CPU E8400, 4G memory and a
WDC WD1600AAJS-75M0A0 160G SATA disk.

I use 'fallocate' and 'dd' command to create a 256M file.  I compare
three cases, which are fallocate w/o new flag, fallocate w/ new flag,
and dd.  We use these commands to create a file.  Meanwhile w/ journal
and w/o journal are compared.  When I format the filesytem, I use
'-E lazy_itable_init=0' to avoid impact.  I use this command to do the
comparsion:

time for((i=0;i<2000;i++)); \
        do \
        dd if=/dev/zero of=/mnt/sda1/testfile conv=notrunc bs=4k \
        count=1 seek=`expr $i \* 16` oflag=sync,direct 2>/dev/null; \
        done


The result:

nojournal:
        fallocte        dd              fallocate w/ new flag
real    0m4.196s        0m3.720s        0m3.782s
user    0m0.167s        0m0.194s        0m0.192s
sys     0m0.404s        0m0.393s        0m0.390s

data=journal:
        fallocate       dd              fallocate w/ new flag
real    1m9.673s        1m10.241s       1m9.773s
user    0m0.183s        0m0.205s        0m0.192s
sys     0m0.397s        0m0.407s        0m0.398s

data=ordered
        fallocate       dd              fallocate w/ new flag
real    1m16.006s       0m18.291s       0m18.449s
user    0m0.193s        0m0.193s        0m0.201s
sys     0m0.384s        0m0.387s        0m0.381s

data=writeback
        fallocate       dd              fallocate w/ new flag
real    1m16.247s       0m18.133s       0m18.417s
user    0m0.187s        0m0.193s        0m0.205s
sys     0m0.401s        0m0.398s        0m0.387s

As result shows, in nojournal mode, the slowdown in w/ conversion case
is not very severe.  Obviously it is caused by initializing an unwritten
extent.  This patch set aims to reduce this overhead.  So we can go on
discussing whether this patch set is acceptable or not.  Certainly, if
most of developers strongly object it, just leave it in mailing list.

In journal mode, we can see, when data is set to 'journal', the result
is almost the same.  However, when data is set 'ordered' or 'writeback',
the slowdown in w/ conversion case is severe.  Then I do the same test
without 'oflag=sync,direct', and the result doesn't change.  IMHO, I
guess that journal is the *root cause*.  Until now, I don't have a
definitely conclusion, and I will go on traing this issue.  Please feel
free to comment it.

Thanks to all who reply the mail. :-)

Regards,
Zheng
