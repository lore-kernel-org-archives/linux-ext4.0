From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Weird filesystem corruption from wayland / radeon / chromium
Date: Tue, 13 Nov 2012 12:28:49 -0600
Message-ID: <50A29161.4060506@redhat.com>
References: <20120903220213.GE19158@chaosreigns.com> <20120904032919.GJ5066@thunk.org> <20120905024848.GK19158@chaosreigns.com> <20120905033818.GL19158@chaosreigns.com> <87liekovgo.fsf@passepartout.tim-landscheidt.de> <509401E2.30402@redhat.com> <878vajq1g6.fsf@passepartout.tim-landscheidt.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab2KMS2u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2012 13:28:50 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qADISoVU007516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 13 Nov 2012 13:28:50 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qADISnjg021138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 13 Nov 2012 13:28:49 -0500
In-Reply-To: <878vajq1g6.fsf@passepartout.tim-landscheidt.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/2/12 1:55 PM, Tim Landscheidt wrote:
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> [...]
>>> Shortly after starting Chrome, the messages reappeared
>>> again:
> 
>>> | Nov  2 15:15:48 passepartout kernel: [ 1979.196296] EXT4-fs error (device dm-4): ext4_ext_search_left:1304: inode #274258: comm flush-253:4: ix (3666) != EXT_FIRST_INDEX (0) (depth 0)!
>>> | Nov  2 15:15:48 passepartout kernel: [ 1979.196306] EXT4-fs (dm-4): delayed block allocation failed for inode 274258 at logical offset 3672 with max blocks 2 with error -5
>>> | Nov  2 15:15:48 passepartout kernel: [ 1979.196308] EXT4-fs (dm-4): This should not happen!! Data will be lost
>>> | Nov  2 15:15:48 passepartout kernel: [ 1979.196308]
> 
>>> And indeed:
> 
>>> | [root@passepartout ~]# find ~tim -inum 274258
>>> | /home/tim/.cache/google-chrome/Default/Cache/data_3
>>> | [root@passepartout ~]#
> 
>>> So somehow Chromium/Chrome seems to be able to trigger ker-
>>> nel messages indicating a file system error while no actual
>>> file system errors seem to occur (very big assumption here
>>> because I have no idea how to detect if "data_3" is cor-
>>> rupted).
> 
>> So it's the same inode every time.
> 
>> What does
> 
>> # debugfs -R "dump_extents <274258>" /dev/dm-4
> 
>> show? (or whatever the appropriate device node path is)
> 
> See attachment.

Level Entries       Logical          Physical Length Flags
 0/ 1   1/  2     0 -  3665 1114157             3666
 1/ 1   1/ 59     0 -   132  510721 -  510853    133 
 1/ 1   2/ 59   133 -   139  511415 -  511421      7 
...
 1/ 1  58/ 59  3039 -  3664  573440 -  574065    626 
 1/ 1  59/ 59  3665 -  4092  574066 -  574493    428 
 0/ 1   2/  2  3666 -  9217  395702             5552
 1/ 1   1/307  4093 -  4093  574494 -  574494      1 
 1/ 1   2/307  4094 -  4095  395758 -  395759      2 
...

Ok, so the first top-level record says it covers logical 0->3665,
but the last extent actually goes from 3665->4092.

Then the next top level extent says it covers 3666->9217,
but that overlaps w/ the last real extent just prior, and
the first allocated extent under it actually starts at 4093.

so,
a) how'd it get into this state, and
b) why doesn't fsck care ...

Looking into that . . .

-Eric
