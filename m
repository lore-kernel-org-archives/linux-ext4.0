From: David Newall <davidn@davidnewall.com>
Subject: Re: zero out blocks of freed user data for operation a virtual machine
 environment
Date: Mon, 25 May 2009 12:59:24 +0930
Message-ID: <4A1A1094.3020903@davidnewall.com>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: Thomas Glanzmann <thomas@glanzmann.de>, tytso@thunk.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hawking.rebel.net.au ([203.20.69.83]:45080 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZEYD32 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 23:29:28 -0400
In-Reply-To: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thomas Glanzmann wrote:
> If you don't intend to have such an optional feature in ext3/ext4 I
> would like to know if you know a tool that makes it possible to zero out
> unused blocks?
>
> The only reference that I found for such a tool for Linux is the
> following:
>   
Astounding use of backquote. I'm not sure about the "percent" bit. I
think it's some confusion over only 95% of total blocks being available
for allocation.

I, too, would not recommend it, but it becomes safer by repeatedly
allocating only half the remaining disk, stopping when there's only a
few blocks free, to leave some for all of the other processes.
Presumably it won't be a problem having (potentially) a few free blocks
that don't de-duplicate.

#!/bin/bash
FileSystem=`grep ext /etc/mtab| awk -F" " '{ print $2 }'`

for i in $FileSystem
do
       while number=`df -B 512 $i | awk -F" " '$4 < 10 {exit(1)} {print $4 / 2}'`
       do
              dd count=$number if=/dev/zero || break
       done > $i/zf
       rm -f $i/zf
done



Are you proposing to de-duplicate a live filesystem?
