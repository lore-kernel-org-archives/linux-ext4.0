From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Weird filesystem corruption from wayland / radeon / chromium
Date: Fri, 02 Nov 2012 12:24:50 -0500
Message-ID: <509401E2.30402@redhat.com>
References: <20120903220213.GE19158@chaosreigns.com> <20120904032919.GJ5066@thunk.org> <20120905024848.GK19158@chaosreigns.com> <20120905033818.GL19158@chaosreigns.com> <87liekovgo.fsf@passepartout.tim-landscheidt.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759416Ab2KBRYv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Nov 2012 13:24:51 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA2HOp9O007326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 2 Nov 2012 13:24:51 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qA2HOoTn026994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 2 Nov 2012 13:24:51 -0400
In-Reply-To: <87liekovgo.fsf@passepartout.tim-landscheidt.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/2/12 10:50 AM, Tim Landscheidt wrote:
> (anonymous) wrote:
> 
>> FYI, after fsck'ing, I checked my filesystem against my backup, and didn't
>> find anything that changed that shouldn't have changed.  Command I used
>> was:
> 
>> rsync -imva --compare-dest=/ /media/4tb/bak/dancer-2012-09-04/ /media/4tb/bak/changes/
> 
> I ran (or rather run) into this issue as well.  Starting on
> October 22nd, I saw on my Fedora 16 (3.6.2-1.fc16.i686) sys-
> tem:
> 
> | Oct 22 13:56:44 passepartout kernel: [ 1395.772939] EXT4-fs error (device dm-4): ext4_ext_search_left:1238: inode #274258: comm flush-253:4: ix (3666) != EXT_FIRST_INDEX (0) (depth 0)!
> | Oct 22 13:56:44 passepartout kernel: [ 1395.772951] EXT4-fs (dm-4): delayed block allocation failed for inode 274258 at logical offset 3666 with max blocks 3 with error -5
> | Oct 22 13:56:44 passepartout kernel: [ 1395.772955] EXT4-fs (dm-4): This should not happen!! Data will be lost
> | Oct 22 13:56:44 passepartout kernel: [ 1395.772957]
> 
> and it continued intermittently.  Last message before "yes-
> terday"'s shutdown was:
> 
> | Nov  2 04:14:09 passepartout kernel: [51109.016422] EXT4-fs error (device dm-4): ext4_ext_search_left:1304: inode #274258: comm flush-253:4: ix (3666) != EXT
> | _FIRST_INDEX (0) (depth 0)!
> | Nov  2 04:14:09 passepartout kernel: [51109.016428] EXT4-fs (dm-4): delayed block allocation failed for inode 274258 at logical offset 3792 with max blocks 2
> |  with error -5
> | Nov  2 04:14:09 passepartout kernel: [51109.016431] EXT4-fs (dm-4): This should not happen!! Data will be lost
> | Nov  2 04:14:09 passepartout kernel: [51109.016431]
> 
> Looking at today's boot.log, I see no error detected by
> "File System Check", and the manual run of "e2fsck -f"
> showed also no errors.
> 
> Shortly after starting Chrome, the messages reappeared
> again:
> 
> | Nov  2 15:15:48 passepartout kernel: [ 1979.196296] EXT4-fs error (device dm-4): ext4_ext_search_left:1304: inode #274258: comm flush-253:4: ix (3666) != EXT_FIRST_INDEX (0) (depth 0)!
> | Nov  2 15:15:48 passepartout kernel: [ 1979.196306] EXT4-fs (dm-4): delayed block allocation failed for inode 274258 at logical offset 3672 with max blocks 2 with error -5
> | Nov  2 15:15:48 passepartout kernel: [ 1979.196308] EXT4-fs (dm-4): This should not happen!! Data will be lost
> | Nov  2 15:15:48 passepartout kernel: [ 1979.196308]
> 
> And indeed:
> 
> | [root@passepartout ~]# find ~tim -inum 274258
> | /home/tim/.cache/google-chrome/Default/Cache/data_3
> | [root@passepartout ~]#
> 
> So somehow Chromium/Chrome seems to be able to trigger ker-
> nel messages indicating a file system error while no actual
> file system errors seem to occur (very big assumption here
> because I have no idea how to detect if "data_3" is cor-
> rupted).

So it's the same inode every time.

What does

# debugfs -R "dump_extents <274258>" /dev/dm-4

show? (or whatever the appropriate device node path is)

You might also create an e2image -r fs image so we could
take a closer look later if needed.  You could provide it offline if
filenames are sensitive (no file data is contained in the image).
Or you could use the filename obfuscation option.

But creating the e2image now just to capture the state might
be good.

-Eric

> In my yum.log, I don't see any obvious package update prior
> to October 22nd.  kernel was updated on October 23rd, Chrome
> on October 12th (22.0.1229.94-161065.i386).
> 
> Any ideas?
> 
> TIA,
> Tim
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

