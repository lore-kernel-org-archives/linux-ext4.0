From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Mon, 21 Jun 2010 11:02:20 -0600
Message-ID: <90E16F6C-6F58-4463-B0F8-D8ABE10321FE@oracle.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:60877 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab0FURCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jun 2010 13:02:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sigh, it seems I was unsubscribed a while ago from linux-fsdevel and linux-ext4 for some reason.  I was CC'd on enough emails that I didn't notice it until the call today.

On 06/14/2010 09:39 AM, Theodore Ts'o wrote:
> With this change you need to add the following to your
> /etc/mke2fs.conf file if you want to enable the 64-bit feature flag automatically for a big disk:
> 
> [fs_types]
> 	ext4 = {
> 		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
> 		auto_64-bit_support = 1   #<---- add this line

It is kind of awkward to have both underscores and hyphens in the same parameter.  What about just using "auto_64bit_support", since the feature is also called "64bit" and not "64-bit"?

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

