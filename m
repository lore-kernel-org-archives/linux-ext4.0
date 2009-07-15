From: Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH 1/2] HACK: ext3: mount fast even when recovering
Date: Wed, 15 Jul 2009 18:35:45 +0300
Message-ID: <4A5DF751.5020105@nokia.com>
References: <20090714140253.25993.64525.sendpatchset@ahunter-tower> <20090714140301.25993.97749.sendpatchset@ahunter-tower> <20090714212221.GD4829@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:64168 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbZGOPfT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 11:35:19 -0400
In-Reply-To: <20090714212221.GD4829@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jul 14, 2009  17:03 +0300, Adrian Hunter wrote:
>> Speed up ext3 recovery mount time by not sync'ing the
>> block device.  Instead place all dirty buffers into the
>> I/O queue and add a write barrier.  This ensures that
>> no subsequent write will reach the disk before all the
>> recovery writes, but that we do not have to wait for the
>> I/O.
>>
>> +	/*
>> +	 * Set an option to indicate that we want to mount fast even
>> +	 * when recovering.  That is achieved by not sync'ing the
>> +	 * block device, but instead placing all dirty buffers into
>> +	 * the I/O queue and adding a write barrier.
>> +	 */
>> +	set_opt(sbi->s_mount_opt, FAST);
> 
> Is there ever a time where one wouldn't want to do a fast mount?
> Surely if this speeds things up and is safe, it makes sense to do
> it always.  If it isn't safe to do always, then would you EVER want
> to do it if you risk corrupting your filesystem?

This is the first hack.  It is safe, it is just not very useful.

The file system mounts fast, but will wait on the very first
operation.

So there are three reasons for it to be optional:
	1. It is not generally useful
	2. The risk it is flawed can be avoided
	3. The slower first operation might upset some users

The second hack allows read operations to proceed, but
may not be safe depending on what other file systems
may be on other partitions of the same block device.


