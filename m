From: Asdo <asdo@shiftmail.org>
Subject: Re: Sync does not flush to disk!?
Date: Fri, 08 Jun 2012 13:39:41 +0200
Message-ID: <4FD1E47D.2050908@shiftmail.org>
References: <4FD1CB8A.9080805@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:4946 "EHLO
	blade3.isti.cnr.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2FHLjf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jun 2012 07:39:35 -0400
In-reply-to: <4FD1CB8A.9080805@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/08/12 11:53, Asdo wrote:
> .....
> Then I tried to do :
>
> for i in /dev/md? /dev/sda /dev/sdb ; do blockdev --flushbufs $i ; done
> ....
> and NOW it is seeing the changes.

After some further tests:
Flushbuf'ing just the MD devices only, generated an even more 
intermediate situation in which the file being changed assumed garbage 
content coming from another old file.
Flushbufing just /dev/sda /dev/sdb has worked a few times I tried. I'm 
not sure that it is enough in general.
Flushbufing everything appears to work reliably.

Still I am puzzled. Wasn't "sync" from bash enough to commit to disk 
even in case of power failure?

Or is there any chance that KVM "sees" a version of sda and sdb which is 
actually *older* than the actual content on the platters?

Thank you
