From: "Vitaliy Filippov" <vitalif@yourcmc.ru>
Subject: Re: mke2fs options for large media archive filesystem
Date: Mon, 03 Feb 2014 11:15:20 +0400
Message-ID: <op.xao2fube0ncgu9@vitalif.vhome>
References: <52EE703B.3010703@gmail.com> <op.xanxpcwg0ncgu9@vitalif.vhome>
 <F3EDB2EF-E089-486A-B1FC-6395770B111E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
Content-Transfer-Encoding: 7BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Bastien Traverse" <bastien.traverse@gmail.com>
To: "Andreas Dilger" <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yourcmc.ru ([195.24.71.121]:40758 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaBCHPi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Feb 2014 02:15:38 -0500
In-Reply-To: <F3EDB2EF-E089-486A-B1FC-6395770B111E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I would say that bigalloc is probably not what you want for an archival  
> system. It is relatively new and the space savings is minimal. It is  
> mostly for filesystems that need to allocate and free large files  
> rapidly.

And does it introduce any memory usage benefit? Maybe not on a 1TB, but on  
a 32TB partition? :)
I.e. does the kernel keep full block bitmap (or maybe a tree of blocks?)  
in memory, or does it read parts of it when they're needed?

-- 
With best regards,
   Vitaliy Filippov
