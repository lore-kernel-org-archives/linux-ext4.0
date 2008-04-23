From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 0/4] jbd: possible filesystem corruption fixes
Date: Wed, 23 Apr 2008 21:45:49 +0900
Message-ID: <480F2F7D.7060303@hitachi.com>
References: <48089B86.5020108@hitachi.com>
    <20080418140946.GA26062@unused.rdu.redhat.com>
    <1208546807.9475.4.camel@localhost.localdomain>
    <20080421210738.GN2775@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, Josef Bacik <jbacik@redhat.com>,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56448 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbYDWMqA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 08:46:00 -0400
In-Reply-To: <20080421210738.GN2775@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:

> On Apr 18, 2008  12:26 -0700, Mingming Cao wrote:
> 
>>On Fri, 2008-04-18 at 10:09 -0400, Josef Bacik wrote:
>>
>>>On Fri, Apr 18, 2008 at 10:00:54PM +0900, Hidehiro Kawai wrote:
>>>
>>>>Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes
>>>>
>>>>The current JBD is not sufficient for I/O error handling.  It can
>>>>cause filesystem corruption.   An example scenario:
>>>>
>>>>1. fail to write a metadata buffer to block B in the journal
>>>>2. succeed to write the commit record
>>>>3. the system crashes, reboots and mount the filesystem
>>>>4. in the recovery phase, succeed to read data from block B
>>>>5. write back the read data to the filesystem, but it is a stale
>>>>   metadata
>>>>6. lose some files and directories!
>>>>
>>>>This scenario is a rare case, but it (temporal I/O error)
>>>>can occur.  If we abort the journal between 1. and 2., this
>>>>tragedy can be avoided.
>>>>
>>>>This patch set fixes several error handling problems to protect
>>>>from filesystem corruption caused by I/O errors.  It has been
>>>>done only for JBD and ext3 parts.
>>
>>Could you sent Ext4/JBD2 version patches? Thanks!
> 
> 
> Actually, the journal checksum in ext4/jbd2 detects this kind of error,
> as well as errors that are NOT reported to the caller (e.g. media errors
> not reported to the kernel).

It's interesting feature.  I read the journal checksum patch,
it seems to fix the problem addressed by PATCH 3/4.
However, journal checksum feature is optional, so PATCH 3/4
will be needed as long as checksuming feature isn't turned
on always.

> One question is whether we want to _introduce_ a point of failure to the
> filesystem that may never actually cause a problem for the system,
> since the journal is only needed in the case of a crash.  By aborting
> the journal at this point instead of letting the checkpoint write the
> data to the filesystem then we are guaranteed a filesystem failure
> instead of "likely no problem at all".

I think it depends on the system and administrator.
When we failed to write metadata to the journal, we...

  (a) abort journaling
      - the filesystem can keep a consistent state if the system
        crashed
      - the system will stop because the filesystem becomes read-only
        state (default)
  (b) only do printk()
      - the system can continue to work
      - bad journalled data may break the file system if the system
        crashed

A user who demands high data integrity will choose (a), and
a user who demands high availability will choose (b).
We might want to enable the user to specify the behavior
on error such as the "errors" mount option.

 
> The journal checksum would detect the bad data in the transaction in the
> cases where it is important, and during operation it makes more sense
> to report the error via printk() so the administrator has some chance to
> do something about it.  There is no reason why the jbd2 change couldn't be
> merged back to jbd so ext3 could use the journal checksumming.  It is a
> "COMPAT" journal feature.

It's interesting.  For example, when a fsync operation is issued,
commit the current transaction, then read the journalled data of
that transaction to check the checksum.  If the bad data is detected,
flush the whole journal.  Aborting the journal will also make sense
because the journal space is errorneous.

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

