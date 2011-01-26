From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCHSET] Refactor barrier=/nobarrier flags from fs to block
 layer
Date: Wed, 26 Jan 2011 06:49:24 -0500
Message-ID: <4D400A44.6030502@redhat.com>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
	axboe@kernel.dk, tytso@mit.edu, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, jack@suse.cz, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, hch@lst.de, josef@redhat.com
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab1AZLuC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jan 2011 06:50:02 -0500
In-Reply-To: <20110126071200.GE32261@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/26/2011 02:12 AM, Darrick J. Wong wrote:
> Hello,
>
>  From what I can tell, most of the filesystems that know how to issue commands
> to flush the write cache also have some mechanism for the user to override
> whether or not the filesystem actually issues those flushes.  Unfortunately,
> the term "barrier" is obsolete having been changed into flushes in 2.6.36, and
> many of the filesystems implement the mount options with slightly different
> syntaxes (barrier=[0|1|none|flush], nobarrier, etc).
>
> This patchset adds to the block layer a sysfs knob that an administrator can
> use to disable flushes, and removes the mount options from the filesystem code.
> As a starting point, I'm removing the mount options and flush toggle from
> jbd2/ext4.
>
> Anyway, I'm looking for some feedback about refactoring the barrier/flush
> control knob into the block layer.  It sounds like we want a knob that picks
> the safest option (issue flushes when supported) unless the administrator
> decides that it is appropriate to do otherwise.  I suspect that there are good
> arguments for not having a knob at all, and good arguments for a safe knob.
> However, since I don't see the barrier options being removed en masse, I'm
> assuming that we still want a knob somewhere.  Do we need the ignore_fua knob
> too?  Is this the proper way to deprecate mount options out of filesystems?
>
> --D

Just to be clear, I strongly object to remove the mount options.

"Barrier" and "poke a control knob in the block" layer are both equally 
mysterious and meaningless to real users, so I do not see this as a gain,

Ric

