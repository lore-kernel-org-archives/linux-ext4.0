From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: RHEL e2fsprogs-1.40.4-sb_feature_check_ignore.patch
Date: Fri, 18 Jul 2014 17:32:00 -0500
Message-ID: <53C9A060.6090403@redhat.com>
References: <CFEED6C0.B22C8%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbaGRWcC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2014 18:32:02 -0400
In-Reply-To: <CFEED6C0.B22C8%andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/18/14, 2:50 PM, Dilger, Andreas wrote:
> I was looking through the RHEL e2fsprogs.spec file and saw that you are
> still
> carrying the e2fsprogs-1.40.4-sb_feature_check_ignore.patch to avoid
> problems
> if the kernel sets xattrs on a new filesystem and doesn't copy this into
> the
> backup superblock.

Ugh, yeah, that's just been there forever, TBH, I forgot about it.
I'll actually have to refamiliarize myself with why it showed up years
ago!  :)

> It seems that mke2fs enables the xattr feature in the superblock by default
> for all filesystems (courtesy of misc/default_profile.c), and e2fsck
> doesn't
> drop COMPAT_EXT_XATTR even if the filesystem doesn't have xattrs, so most
> of
> the danger of not having this patch are behind us.
> 
> That said, it probably still makes sense to include this patch into the
> upstream e2fsprogs, unless there is some reason not to?  It looks pretty
> low risk.

Well, ISTR at the time I added it, it was a hacky workaround, rather than 
a proper fix.  I'll have to look at it again.

-eric
 
> Cheers, Andreas
> 

