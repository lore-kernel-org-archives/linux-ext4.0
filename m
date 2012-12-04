From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: next: ext4 build failure
Date: Tue, 04 Dec 2012 14:29:40 +0100
Message-ID: <50BDFAC4.6040407@suse.cz>
References: <50BDC25C.5020509@suse.cz> <20121204132701.GA29083@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, boyu.mt@taobao.com,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62739 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2LDN3p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2012 08:29:45 -0500
In-Reply-To: <20121204132701.GA29083@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/04/2012 02:27 PM, Theodore Ts'o wrote:
> On Tue, Dec 04, 2012 at 10:29:00AM +0100, Jiri Slaby wrote:
>> Hi,
>>
>> commit a7b0168d4a9bb78535827ddaf9c055963f5bd7aa
>> Author: Tao Ma <boyu.mt@taobao.com>
>> Date:   Sun Dec 2 20:30:52 2012 -0500
>>
>>     ext4: let fallocate handle inline data correctly
>>
>> added
>>
>> static int int ext4_convert_inline_data(struct inode *inode)
>>
>>        ^^^^^^^
>>
>> when EXT4_FS_XATTR is unset.
>>
>> Care to fix that?
> 
> Oops.  Thanks for catching this!!!

This is not the only one BTW, see:
http://decibel.fi.muni.cz/gitweb/?p=linux.git;a=commitdiff;h=1a166497fe3d76e5af8af02e2ee5a967b2829b93

thanks,
-- 
js
suse labs
