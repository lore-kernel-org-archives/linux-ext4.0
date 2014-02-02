From: "Vitaliy Filippov" <vitalif@yourcmc.ru>
Subject: Re: mke2fs options for large media archive filesystem
Date: Sun, 02 Feb 2014 20:35:26 +0400
Message-ID: <op.xanxpcwg0ncgu9@vitalif.vhome>
References: <52EE703B.3010703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org,
	"Bastien Traverse" <bastien.traverse@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yourcmc.ru ([195.24.71.121]:49673 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbaBBQfa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Feb 2014 11:35:30 -0500
In-Reply-To: <52EE703B.3010703@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> b) bigalloc feature

As I understand (please correct me someone if I'm wrong), given that ext4  
uses extents, bigalloc feature is really useful ONLY for minimizing block  
bitmaps. Which is probably only useful for (maybe) reducing kernel memory  
usage and for (maybe) reducing fragmentation. 'maybe' means I personally  
don't know if benefit will be large enough, and I even don't know if there  
would be any real benefit at all... I didn't see any real bigalloc tests  
in the web...

So, I personally don't think you'll really benefit from bigalloc on a 1TB  
archive partition... But I would like it very much if someone can tell an  
authoritative verdict. :)

-- 
With best regards,
   Vitaliy Filippov
