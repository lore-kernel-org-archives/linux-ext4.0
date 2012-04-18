From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 20:06:00 +0800
Message-ID: <20120418120600.GC3447@gmail.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
 <4F8DAAFE.40500@redhat.com>
 <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com>
 <20120418113810.GA3447@gmail.com>
 <alpine.LFD.2.00.1204181336440.5310@dhcp-27-109.brq.redhat.com>
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
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52554 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2DRL7c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Apr 2012 07:59:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1204181336440.5310@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 18, 2012 at 01:39:06PM +0200, Lukas Czerner wrote:
> On Wed, 18 Apr 2012, Zheng Liu wrote:
> 
> > > I auspect the real problem may be the lazy inode table zeroing being done in the kernel. If the test is run immediately after formatting the filesystem, then the kernel thread is busy writing to the disk in the background and interfering with your benchmark.
> > > 
> > > Please format the filesystem with "-E lazy-itable-init=0", to avoid this behavior.  
> > 
> > I format the filesystem with this option, but it seems that it is
> > useless.
> 
> What do you mean by that ? It does not work as it's supposed to ?
> ext4lazyinit kernel thread is still running ? Or the slowdown was not
> caused by the lazy init in the first place ?

Sorry, I have used this option and retry to run the benchmark, but the
slowdown is still in there.

Regards,
Zheng
