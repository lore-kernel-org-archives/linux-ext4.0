From: Arturas K <arturas@cerberis.soften.ktu.lt>
Subject: Re: rm: cannot remove `???': No such file or directory
Date: Tue, 25 Nov 2008 11:50:46 +0200
Message-ID: <492BCA76.50308@cerberis.soften.ktu.lt>
References: <492AB6C5.1050609@cerberis.soften.ktu.lt> <20081125063558.GG20928@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cerberis.soften.ktu.lt ([193.219.33.193]:55174 "EHLO
	cerberis.soften.ktu.lt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYKYJu7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 04:50:59 -0500
In-Reply-To: <20081125063558.GG20928@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Nov 24, 2008 at 04:14:29PM +0200, Arturas K wrote:
>> hello,
>>
>> I did a simple/dirty benchmark on multiple file systems, and ext4dev  
>> encounters some problems recursively removing linux tree... tested with  
>> default and multiple altered option sets of mkfs.ext4dev and/or mount  
>> options - the same story :(
> 
> What kernel version were you using?
> 
> 							- Ted

hi,

as I written before:

--- system ---

ubuntu 8.10 amd64

 > ~# dpkg -l | grep linux-image-2.6.27
 > ii  linux-image-2.6.27-7-generic 2.6.27-7.16
 > ~# dpkg -l | grep e2fs
 > ii  e2fslibs 1.41.3-1ubuntu1
 > ii  e2fsprogs 1.41.3-1ubuntu1

---
ArturasK.
