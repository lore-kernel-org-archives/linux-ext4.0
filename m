From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCHSET] Refactor barrier=/nobarrier flags from fs to block
 layer
Date: Wed, 26 Jan 2011 06:47:16 -0500
Message-ID: <4D4009C4.3080007@redhat.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110126071200.GE32261@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/26/2011 02:12 AM, Darrick J. Wong wrote:
> Hello,
>
>  From what I can tell, most of the filesystems that know how to issue commands
> to flush the write cache also have some mechanism for the user to override
> whether or not the filesystem actually issues those flushes.  Unfortunately,
> the term "barrier" is obsolete having been changed into flushes in 2.6.36, and
> many of the filesystems implement the mount options with slightly different
> syntaxes (barrier=[0|1|none|flush], nobarrier, etc).

Why remove the mount option? We have been using that term and educating users 
about how to use it for many, many years.

I see no reason to remove mount options at all.

Ric

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
