From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fsfuzzer: exabyte file sizes
Date: Fri, 25 Nov 2011 22:26:17 -0700
Message-ID: <7A91398C-F5FF-4A8E-AD44-291B6DFA68A5@dilger.ca>
References: <20111122101050.GK5832@mwanda>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:55996 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1KZF0T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Nov 2011 00:26:19 -0500
In-Reply-To: <20111122101050.GK5832@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-22, at 3:10 AM, Dan Carpenter wrote:
> I'm messing with fsfuzzer and it created a filesystem with a huge
> exabyte file which is larger than ext4 supports.
> 
> root@elgon:/tmp# mount -o loop ext4_exabyte_file.img mnt/
> root@elgon:/tmp# ls -l mnt/
> ls: cannot access mnt/config.h: Input/output error
> ls: cannot access mnt/configure: Input/output error
> -rw-r--r--     1 root root 9583660007044417438 Nov 21 18:03 config.h.in

I don't know that there is much to be done with this at the ext4 level.
Of course e2fsck should fix this, but that isn't what is being tested here.
I think the best that can be expected of ext4 is that it doesn't crash or
lock up when encountering such files.

It wouldn't be a terrible exercise to run fsfuzzer against some filesystem
and then run e2fsck on it.  It should be able to fix any problem in the
first run, and the filesystem should be totally clean on the second run.

Cheers, Andreas





