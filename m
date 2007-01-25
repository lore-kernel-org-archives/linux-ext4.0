From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: support freeze operation like xfs_freeze
Date: Thu, 25 Jan 2007 13:40:58 -0600
Message-ID: <45B907CA.70309@redhat.com>
References: <20070125172818.GA25037@swszl.szkp.uni-miskolc.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Vitez Gabor <vitezg@niif.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030525AbXAYTlv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jan 2007 14:41:51 -0500
In-Reply-To: <20070125172818.GA25037@swszl.szkp.uni-miskolc.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Vitez Gabor wrote:
> Hi,
> 
> It would be really great if ext4 supported an xfs_freeze like operation. 
> On xfs it spared me a lot of headaches when I was playing with unstable 
> kernel features.
> 
>   thanks
>     Gabor
>

Right now ext3 and ext4 -can- be frozen, but only via devicemapper,
because the call to freeze_bdev is only exposed via

<dm ioctl>
  dev_suspend
    do_suspend
      dm_suspend
        lock_fs
          freeze_bdev <-- generic, exported kernel function

on an lvm volume.  So, I think ext[34] are perfectly capable of being
frozen, there's just no generic userspace utility to point at a generic
block device to do that freezing.  xfs's collection of ioctls to do this
directly got grandfathered in, I guess.  :)

-Eric
