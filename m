From: Dai Xiang <xiangx.dai@intel.com>
Subject: Re: How to enable CONFIG_EXT4_ENCRYPTION
Date: Mon, 7 Aug 2017 17:51:26 +0800
Message-ID: <20170807095126.hyhrrnr4vrj3ne4k@linux>
References: <20170807032502.2tiyjybtqrn6odab@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xiang Dai <xiangx.dai@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:8005 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752367AbdHGJv2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Aug 2017 05:51:28 -0400
Content-Disposition: inline
In-Reply-To: <20170807032502.2tiyjybtqrn6odab@linux>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 07, 2017 at 11:25:02AM +0800, Dai Xiang wrote:
> Hi!
> 
> I use xfstests with ext4 fs to test, and i found a skip:
> 
> ext4/024         [not run] kernel does not support ext4 encryption

i print the cmd:
/usr/sbin/xfs_io -i -c set_encpolicy /fs/scratch/tmpdir
/fs/scratch/tmpdir: failed to set encryption policy: Inappropriate
ioctl for device <===

Seems do not related to kconfig?

/dev/vdd on /fs/scratch type ext4 (rw,relatime,data=ordered)
df -T /dev/vdd
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/vdd       ext4  251G   86G  154G  36% /fs/scratch
> 
> I have rebuild config with CONFIG_FS_ENCRYPTION and CONFIG_EXT4_ENCRYPTION.
> I try to set them both y and both m, but two ways both do not set and do not find related failure log.
> I use v4.13-rc3 kernel to build.
> 
> Do i miss some dependence kconfig?
> 
> Thanks
> Xiang
