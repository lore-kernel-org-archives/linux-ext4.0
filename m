From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Add a norecovery option to ext3/4?
Date: Mon, 09 Apr 2007 12:21:15 -0500
Message-ID: <461A760B.1040103@redhat.com>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbXDIRXw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Apr 2007 13:23:52 -0400
In-Reply-To: <461A5F13.7040705@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Phillip Susi wrote:
> Samuel Thibault wrote:
>> Hi,
>>
>> Distribution installers usually try to probe OSes for building a suited
>> grub menu.  Unfortunately, mounting an ext3 partition, even in read-only
>> mode, does perform some operations on the filesystem (log recovery).
>> This is not a good idea since it may silently garbage data.  XFS has a
>> norecovery option that allows to disable that, I'd say ext3/4 should
>> have it too.
> 
> When the filesystem is told to mount the disk read only, that means it 
> should not write to it.  

It means the filesystem should not be writeable when it is mounted.
This is not the same as saying that the filesystem itself should do no
IO in the course of making that read-only mount available.

> The fact that ext3 goes ahead and does anyway 
> is a bug and should be fixed.  There is no need for a norecovery option, 
> because read only is a sufficient directive to tell the filesystem not 
> to write to the disk.

I respectfully disagree, see above.

> As someone else pointed out, this behavior causes havoc if you hibernate 
> a system and then boot up another system which mounts the disk of the 
> hibernated system.  

In that case you are mounting the same filesystem uner 2 different
operating systems simultaneously, which is, and always has been, a
recipe for disaster.  Flagging the fs as "mounted already" would
probably be a better solution, though it's harder than it sounds at
first glance.

> Under all conditions it should be safe to mount a 
> disk read only, but here it is not because the journal playback trashes 
> the disk out from under the hibernated system.

Under all conditions it should be safe to mount a read-only block
device, but that is not the same as mounting a filesystem read-only.

-Eric
