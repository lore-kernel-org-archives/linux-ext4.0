From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] e2fsprogs: enable user namespace xattrs by default
Date: Wed, 16 Feb 2011 12:15:27 -0700
Message-ID: <C637E27A-6E13-4950-B4CC-0451FDB421B9@dilger.ca>
References: <4D5C1380.2020602@redhat.com> <4D5C15C6.5000802@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40202 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab1BPTPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Feb 2011 14:15:21 -0500
In-Reply-To: <4D5C15C6.5000802@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-16, at 11:21, Eric Sandeen wrote:
> User namespace xattrs are generally useful, and I think extN
> is the only filesystem requiring a special mount option to
> enable them, when xattrs are otherwise available.  So this
> change sets that mount option into the defaults.
> 
> Note that if xattrs are config'd off, this will lead to a
> mostly-harmless:
> 
>   EXT4-fs (sdc1): (no)user_xattr options not supported
> 
> message at mount time... 

Wouldn't it be more useful to change this in the kernel, instead of only changing it in the superblock for new filesystems?

Cheers, Andreas





