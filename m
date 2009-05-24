From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: zero out blocks of freed user data for operation a virtual machine
	environment
Date: Sun, 24 May 2009 19:00:45 +0200
Message-ID: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: tytso@thunk.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:46875 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbZEXRH1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 May 2009 13:07:27 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ted,
I would like to know if there is already a mount option or feature in
ext3/ext4 that automatically overwrites freed blocks with zeros? If this
is not the case I would like to know if you would consider a patch for
upstream? I'm asking this because I currently do some research work on
data deduplication in virtual machine environments and corresponding
backups. It would be a huge space saver if there is such a feature
because todays and tomorrows backup tools for virtual machine
environments work on the block layer (VMware Consolidated Backup, VMware
Data Recovery, and NetApp Snapshots). This is not only true for backup
tools but also for running Virtual machines. The case that this future
addresses is the following: A huge file is downloaded and later delted.
The backup and datadeduplication that is operating on the block level
can't identify the block as unused. This results in backing up the
amount of the data that was previously allocated by the file and as such
introduces an performance overhead. If you're interested in real live
data, I'm able to provide them.

If you don't intend to have such an optional feature in ext3/ext4 I
would like to know if you know a tool that makes it possible to zero out
unused blocks?

The only reference that I found for such a tool for Linux is the
following:

#!/bin/bash
FileSystem=`grep ext /etc/mtab| awk -F" " '{ print $2 }'`

for i in $FileSystem
do
       number=`df -B 512 $i | awk -F" " '{print $4}'`
       percent=$(echo "scale=0; $number * 95 / 100" | bc )
       dd count=`echo $percent` if=/dev/zero of=`echo $i`/zf
       rm -f $i/zf
done

Source: http://blog.core-it.com.au/?p=298

Even if certainly does job I would hardly recommend it to anyone for various
obvious reasons: A lot of I/O overhead that could be avoided, scheduling
this at the bad moment it could lead to full disk situation. And also
the blocksize is left the default and as such is way to low.

Just to be complete: For Microsoft Windows there is a tool called
sdelete which can be used to zero out unused disk blocks, again it has
the same problem as the above script but hopefully is saver to run.

Source: http://technet.microsoft.com/en-us/sysinternals/bb897443.aspx

        Thomas
