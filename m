From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Mon, 7 May 2007 11:19:52 -0500
Message-ID: <20070507111952.7868bc1c@gara>
References: <20070503140804.463b20e1@naruto>
	<463B4A1B.4070201@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55861 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965475AbXEGQTy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2007 12:19:54 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l47FIImO003367
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 11:18:18 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l47GJpof496574
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 12:19:51 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l47GJpM8024454
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 12:19:51 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l47GJolK024444
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 12:19:50 -0400
In-Reply-To: <463B4A1B.4070201@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 04 May 2007 16:58:35 +0200
Valerie Clement <valerie.clement@bull.net> wrote:
> Hi Jose,
> I began to port our modifications done for the 64-bit support against 
> the new version of e2fsprogs Ted posted at the beginning of the week.
> Note that it is *just* for test use as it breaks the backwards 
> compatibility.
> I did a few tests with a kernel 2.6.17-rc7 and it seems to work, at 
> least mkfs, debugfs and fsck tools.

Hi Valerie,

I tried the patches and while the tools such as mkfs and debugfs seem
to work fine, I am still unable to mount a filesystem with block
numbers exceeding 32 bits.  I am testing on a 2.6.21.1 kernel with the
ext4 patches from:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.21-ext4-1

The following error shows up on the kernel log:

[12145.598822] EXT4-fs error (device dm-2): ext4_check_descriptors: Block bitmap for group 0 not in group (block 18446744069414584320)!
[12145.670781] EXT4-fs: group descriptors corrupted!

So its failing very early in ext4_check_descriptors().  The hi 32 bits of block_bitmap for the first group seem to be set all to 1s.

Thanks

-JRS
