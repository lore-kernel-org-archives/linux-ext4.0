From: Asdo <asdo@shiftmail.org>
Subject: Sync does not flush to disk!?
Date: Fri, 08 Jun 2012 11:53:14 +0200
Message-ID: <4FD1CB8A.9080805@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-raid <linux-raid@vger.kernel.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:3368 "EHLO
	blade3.isti.cnr.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2FHJxD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jun 2012 05:53:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all
I don't exactly know where to ask this question...

I have a situation of

sda1 + sdb1 --> MD raid1
Above that is an ext4 filesystem. No LVM.

I am making changes to that filesystem (vi a file) and then i am doing
sync
sync
(twice)

then I am starting KVM in snapshot mode on the sda and sdb disks so to 
virtualize the same system on which I am operating.

kvm -m 1024 -hda /dev/sda -hdb /dev/sdb -snapshot

The strange thing is that the virtual machine is NOT seeing the latest 
changes to that file!

Then I tried to do :

for i in /dev/md? /dev/sda /dev/sdb ; do blockdev --flushbufs $i ; done

and restart KVM,
and NOW it is seeing the changes.

In the past I had similar problems, and not knowing about blockdev 
--flushbufs I ended up dismounting the filesystems and stopping the 
RAIDs. That also appeared to actually commit stuff to disk.

So sync is not enough? Would somebody explain to me better?

Thank you
