From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext2: Report metadata errors during fsync
Date: Wed, 25 Nov 2009 16:17:32 -0700
Message-ID: <537036C8-472F-4111-8B00-7A637A00845E@sun.com>
References: <1259144693-6732-1-git-send-email-jack@suse.cz>
 <20091125134858.97ca863d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	chris.mason@oracle.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62638 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917AbZKYXR2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Nov 2009 18:17:28 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nAPNHY5Q010819
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2009 15:17:34 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KTO00D00TRD5F00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 25 Nov 2009 15:17:34 -0800 (PST)
In-reply-to: <20091125134858.97ca863d.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-25, at 14:48, Andrew Morton wrote:
> On Wed, 25 Nov 2009 11:24:53 +0100
> Jan Kara <jack@suse.cz> wrote:
>> When an IO error happens while writing metadata buffers, we should
>> better report it and call ext2_error since the filesystem is probably
>> no longer consistent. Sometimes such IO errors happen while flushing
>> thread does background writeback, the buffer gets later evicted  
>> from memory, and thus the only trace of the error remains as AS_EIO  
>> bit
>> set in blockdevice's mapping. So we check this bit in ext2_fsync and
>> report the error although we cannot be really sure which buffer we
>> failed to write.
>
> So this doesn't cause significant changes in runtime behaviour unless
> the operator specified errors=remount-ro or errors=panic?


Debian, at least, always mounts filesystems with errors=remount-ro.

I _was_ thinking that this would cause errors for even regular file
data, but since it is the bdev mapping and regular files have their
own mappings any errors on the regular files should appear on a
different mapping (which is eventually returned via simple_fsync()).

The only errors returned from the bdev mapping should be metadata
errors, and we always want to call ext*_error() for those.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

