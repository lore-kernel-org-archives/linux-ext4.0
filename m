From: Tim Landscheidt <tim@tim-landscheidt.de>
Subject: Re: Weird filesystem corruption from wayland / radeon / chromium
Date: Fri, 02 Nov 2012 15:50:15 +0000
Message-ID: <87liekovgo.fsf@passepartout.tim-landscheidt.de>
References: <20120903220213.GE19158@chaosreigns.com>
	<20120904032919.GJ5066@thunk.org>
	<20120905024848.GK19158@chaosreigns.com>
	<20120905033818.GL19158@chaosreigns.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50458 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab2KBQO5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Nov 2012 12:14:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1TUJtg-0007VR-GP
	for linux-ext4@vger.kernel.org; Fri, 02 Nov 2012 17:15:04 +0100
Received: from g224120190.adsl.alicedsl.de ([92.224.120.190])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 02 Nov 2012 17:15:04 +0100
Received: from tim by g224120190.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 02 Nov 2012 17:15:04 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(anonymous) wrote:

> FYI, after fsck'ing, I checked my filesystem against my backup, and didn't
> find anything that changed that shouldn't have changed.  Command I used
> was:

> rsync -imva --compare-dest=/ /media/4tb/bak/dancer-2012-09-04/ /media/4tb/bak/changes/

I ran (or rather run) into this issue as well.  Starting on
October 22nd, I saw on my Fedora 16 (3.6.2-1.fc16.i686) sys-
tem:

| Oct 22 13:56:44 passepartout kernel: [ 1395.772939] EXT4-fs error (device dm-4): ext4_ext_search_left:1238: inode #274258: comm flush-253:4: ix (3666) != EXT_FIRST_INDEX (0) (depth 0)!
| Oct 22 13:56:44 passepartout kernel: [ 1395.772951] EXT4-fs (dm-4): delayed block allocation failed for inode 274258 at logical offset 3666 with max blocks 3 with error -5
| Oct 22 13:56:44 passepartout kernel: [ 1395.772955] EXT4-fs (dm-4): This should not happen!! Data will be lost
| Oct 22 13:56:44 passepartout kernel: [ 1395.772957]

and it continued intermittently.  Last message before "yes-
terday"'s shutdown was:

| Nov  2 04:14:09 passepartout kernel: [51109.016422] EXT4-fs error (device dm-4): ext4_ext_search_left:1304: inode #274258: comm flush-253:4: ix (3666) != EXT
| _FIRST_INDEX (0) (depth 0)!
| Nov  2 04:14:09 passepartout kernel: [51109.016428] EXT4-fs (dm-4): delayed block allocation failed for inode 274258 at logical offset 3792 with max blocks 2
|  with error -5
| Nov  2 04:14:09 passepartout kernel: [51109.016431] EXT4-fs (dm-4): This should not happen!! Data will be lost
| Nov  2 04:14:09 passepartout kernel: [51109.016431]

Looking at today's boot.log, I see no error detected by
"File System Check", and the manual run of "e2fsck -f"
showed also no errors.

Shortly after starting Chrome, the messages reappeared
again:

| Nov  2 15:15:48 passepartout kernel: [ 1979.196296] EXT4-fs error (device dm-4): ext4_ext_search_left:1304: inode #274258: comm flush-253:4: ix (3666) != EXT_FIRST_INDEX (0) (depth 0)!
| Nov  2 15:15:48 passepartout kernel: [ 1979.196306] EXT4-fs (dm-4): delayed block allocation failed for inode 274258 at logical offset 3672 with max blocks 2 with error -5
| Nov  2 15:15:48 passepartout kernel: [ 1979.196308] EXT4-fs (dm-4): This should not happen!! Data will be lost
| Nov  2 15:15:48 passepartout kernel: [ 1979.196308]

And indeed:

| [root@passepartout ~]# find ~tim -inum 274258
| /home/tim/.cache/google-chrome/Default/Cache/data_3
| [root@passepartout ~]#

So somehow Chromium/Chrome seems to be able to trigger ker-
nel messages indicating a file system error while no actual
file system errors seem to occur (very big assumption here
because I have no idea how to detect if "data_3" is cor-
rupted).

In my yum.log, I don't see any obvious package update prior
to October 22nd.  kernel was updated on October 23rd, Chrome
on October 12th (22.0.1229.94-161065.i386).

Any ideas?

TIA,
Tim

