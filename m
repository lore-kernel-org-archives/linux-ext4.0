From: andreas@rid-net.de
Subject: Re: defragmentation of boot related files
Date: Thu, 26 Aug 2010 22:16:28 +0200
Message-ID: <4C76CB9C.2060207@rid-net.de>
References: <4C7505C3.1070509@rid-net.de>	<4C762AF3.8020303@sx.jp.nec.com> <AANLkTi=zdx6QjsB+EJrOtmpr9BY-j24TGTJaeisAcqu7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Greg Freemyer <greg.freemyer@gmail.com>, k-mio@sx.jp.nec.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:19432 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0HZUQt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 16:16:49 -0400
In-Reply-To: <AANLkTi=zdx6QjsB+EJrOtmpr9BY-j24TGTJaeisAcqu7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

>> Usage: e4defrag -r directory...| device...
>>        e4defrag -r base_file move_file...<--- new
>>

The new interface looks nice. As I see it's easy to implement cause only 
the main-function must be modified. If you have no objections, I will do 
it myself and send you the patch to review it.

> I suspect the original idea would work better because it is more
> likely to pack the libs / files into perfectly contiguous block
> ranges.

I don't know if it makes a difference for the block allocator. Even 
though you know the size of all files to be moved.

For a better result, may it be possible to create a base_file whose 
inode is part of an empty block group?


  Andreas
