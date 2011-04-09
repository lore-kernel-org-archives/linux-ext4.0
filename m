From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: flex_bg with tune2fs posible?
Date: Sat, 9 Apr 2011 17:01:53 -0600
Message-ID: <613129CE-D1B7-46BB-8C0F-B94BB7E2011E@dilger.ca>
References: <20110409215017.GA17008@vip.manty.net>
Mime-Version: 1.0 (iPhone Mail 8F190)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Santiago Garcia Mantinan <manty@manty.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:30313 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab1DIXBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Apr 2011 19:01:49 -0400
In-Reply-To: <20110409215017.GA17008@vip.manty.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-09, at 3:50 PM, Santiago Garcia Mantinan <manty@manty.net> wrote:
> I had converted an ext3 filesystem to ext4 long ago but comparing it's
> features with the ones found on a newly formatted ext4 filesystem I found
> that I had these features missing:
> flex_bg huge_file dir_nlink extra_isize

> Current doc at ext4.wiki.kernel.org says: "There are additional ext4
> features, such as flex_bg and > 16TB filesystem support that can only
> be enabled at format time via mke2fs."
> 
> I did activate all these 4 without any problem (2.6.38 with 1.41.12
> e2fsprogs) is the doc old and doesn't reflect that this is now possible?
> 
> Or have I done something I'll regret?

Technically, flex_bg can be activated after the filesystem is formatted, but it doesn't actually provide the benefit as if enabled at format time.

The dir_nlink and huge_file features can safely be enabled on an existing filesystem, allowing > 64000 subdirs and > 2 TB files, respectively. 

The extra_isize feature will not itself do anything if the filesystem wasn't formatted with large inodes (>128 bytes), though it is possible this was done even for ext3, depending on the version of e2fsprogs used. 

> So far the filesystem seems ok (e2fsck doesn't detect any problems) and
> files seem ok as well.
