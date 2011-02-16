From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/2] e2fsprogs: update mkfs defaults
Date: Wed, 16 Feb 2011 16:37:14 -0600
Message-ID: <4D5C519A.5070106@redhat.com>
References: <4D5C1380.2020602@redhat.com> <AC6734D9-917B-419C-9308-606C919D5F5D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1BPWhR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 17:37:17 -0500
In-Reply-To: <AC6734D9-917B-419C-9308-606C919D5F5D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/16/11 4:12 PM, Andreas Dilger wrote:
> On 2011-02-16, at 11:12, Eric Sandeen wrote:
>> Anaconda (the Fedora/RHEL installer) had been "fixing up" extN
>> filesystems it created by setting the max mount count and check
>> interval to 0, as well as adding user_xattr to filesystem mount
>> options.
>> 
>> As part of their efforts to stop special-casing around upstream
>> defaults, they've removed these changes upstream.
>> 
>> However, I'd like to at least propose that these changes be made
>> default.
> 
> I'd really prefer instead that the "lvcheck" script be included into
> the distro, instead of changing mke2fs.  That achieves the same end
> result (periodic scrubbing of the filesystem to look for hidden
> errors), without introducing boot-time delays.  Given the size of
> disks today and the undetected bit-error-rate (somewhere around
> 1/10^15 bits or 12TB), I think it is important that there be
> automated scrubbing of the filesystem.

lvcheck is well and good, but is not a panacea; it is useful only
for snapshottable volumes.... and only lvm for now?

> I think the best place to put that script would be in the lvm tools
> (since it is applicable to multiple filesystems), which I think Eric
> has the most leverage in getting accepted (I've been but I'd be OK
> including it with e2fsprogs if there is pushback on that.

device-mapper utilities ended up being a black hole... combination
of "the scripts don't conform to our style" or somesuch, but no real
interest in adopting & fixing them to do so, IIRC.

>> The forced fsck often comes at unexpected and inopportune moments,
>> and even enterprise customers are often caught by surprise when
>> this happens.  Because a filesystem with an error condition will be
>> marked as requiring fsck anyway,
> 
> Any decent RAID array does background scrubbing for integrity
> verification, it doesn't just wait until there is an uncorrectable
> error detected in the block device.  If we can do something proactive
> to prevent this (i.e. lvcheck run by cron.weekly), it is worthwhile.

If the raid went offline for a couple hours at random times to do this,
users would scream too.  This is essentially what the forced fsck does
today.

> I think customers are equally surprised when their server fails
> (remount-ro/panic) due to the kernel detecting an error that might
> have been on disk for weeks or months.

If I were an administrator, I would schedule fscks to avoid this, rather
than rely on a "kludgy hack of using the UUID to derive a random" time
for this to hit...

>> I submit that the time-based and mount-based checks are not
>> particularly useful, and that administrators can schedule fscks on
>> their own time, or tune2fs the enforced intervals if they so
>> choose.
> 
> I think you are projecting your own self-enlightenment onto users
> ;-).  As we see on this list, there are many users that don't even
> back up their critical data, so IMHO taking out "safe by default"
> options is a step in the wrong direction.

Perhaps I'll whip up a s_last_backup_time patch, and refuse to mount if
the user hasn't conformed to our enlightened notions of how often is often
enough, as well.  I could integrate it with dumpe2fs.  ;)

There is "safe by default" and then there is "assuming administrator
responsibilities," IMHO.  I just personally think it's too much.

> Attached is my latest version of the lvcheck script, and a default
> /etc/lvcheck.conf script.  It's been enhanced to include a usage
> message, command-line option parsing to override default parameters,
> and the ability to check snapshots of ext3/4 filesystems with an
> external journal.
> 

The script is great, but has limited application.

Well, anyway, I knew this wouldn't be super popular with everyone,
but figured I'd put it out there for discussion.

-Eric
 
> Cheers, Andreas
> 
> 
> 

