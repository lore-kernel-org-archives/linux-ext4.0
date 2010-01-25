From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: IO error semantics
Date: Mon, 25 Jan 2010 12:50:19 -0500
Message-ID: <4B5DD9DB.7070300@redhat.com>
References: <4B4EB5B9.4020809@hitachi.com> <4B4EDE5C.8040600@hitachi.com> <4B4EEE86.7080807@hitachi.com> <20100114141803.GB3146@quack.suse.cz> <20100118051847.GA8678@laptop> <20100118060518.GA9151@laptop> <20100118122437.GF7264@discord.disaster> <20100118140039.GA13909@laptop> <D65C918F-8CCD-4626-BA84-FD0410A5E81F@cam.ac.uk> <4B5DB78D.2090408@redhat.com> <20100125174723.GB28459@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, Anton Altaparmakov <aia21@cam.ac.uk>,
	Nick Piggin <npiggin@suse.de>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hita
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0AYRuv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jan 2010 12:50:51 -0500
In-Reply-To: <20100125174723.GB28459@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/25/2010 12:47 PM, tytso@mit.edu wrote:
> On Mon, Jan 25, 2010 at 10:23:57AM -0500, Ric Wheeler wrote:
>>
>> For permanent write errors, I would expect any modern drive to do a
>> sector remapping internally. We should never need to track this kind
>> of information for any modern device that I know of (S-ATA, SAS,
>> SSD's and raid arrays should all handle this).
>
> ... and if the device is run out of all of its blocks in its spare
> blocks pool, it's probably well past the time to replace said disk.
>
> BTW, I really liked Dave Chinner's summary of the issues involved; I
> ran into Kawai-san last week at Linux.conf.au, and we discussed pretty
> much the same thing over lunch.  (i.e., that it's a hard problem, and
> in some cases we need to retry the writes, such as a transient FC path
> problem --- but some kind of write throttling is critical or we could
> end up choking the VM due to too many pages getting dirtied and no way
> of cleaning them.)
>
> 						- Ted

Also note that retrying writes (or reads for that matter) often are counter 
productive. For those of us who have suffered with trying to migrate data off of 
an old, failing disk onto a new, shiny one, excessive retries can be painful...

ric

