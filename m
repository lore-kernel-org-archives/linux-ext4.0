From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] mke2fs: do not initialize block bitmaps of groups having super block
Date: Wed, 9 Nov 2011 15:34:20 -0500
Message-ID: <D7569AD1-FA75-44A4-BA8E-D47E96E75696@mit.edu>
References: <1320836006-6946-1-git-send-email-xiaoqiangnk@gmail.com> <D8CD6456-1740-4FA6-83E5-EFB0045EE74E@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:44669 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab1KIUj2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Nov 2011 15:39:28 -0500
In-Reply-To: <D8CD6456-1740-4FA6-83E5-EFB0045EE74E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 9, 2011, at 11:23 AM, Andreas Dilger wrote:

> On 2011-11-09, at 3:53 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> 
>> Now mke2fs initializes block bitmaps of groups having super block, on
>> the other hand ext4_init_block_bitmap in kernel can handle this case
>> rightly.  So let mke2fs let block bitmaps of groups having super block
>> be uninitialized.
> 
> Is that true of older kernels, or only newer ones?  What about filesystems with META_BG set?

More to the point, what about file systems that don't have uninit_bg set?

What's the reason for wanting to make this change?

-- Ted


