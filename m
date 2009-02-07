From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] ext4_bmap() may return blocks outside filesystem
Date: Sat, 7 Feb 2009 10:51:51 -0500
Message-ID: <20090207155151.GE29213@mini-me.lan>
References: <498AD58B.5000805@ph.tum.de> <20090205134905.GL8945@mit.edu> <87f94c370902050722wf2099c9i2d815737e85209f3@mail.gmail.com> <498B084F.2060608@redhat.com> <20090205164803.GM8945@mit.edu> <87f94c370902051401s6d73d810s720f187c134f0b1e@mail.gmail.com> <20090205221809.GD9814@mit.edu> <87r62aidh8.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57698 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbZBGR0Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Feb 2009 12:26:24 -0500
Content-Disposition: inline
In-Reply-To: <87r62aidh8.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 07, 2009 at 02:27:31PM +0100, Goswin von Brederlow wrote:
> I see the following scenario:
> 
> 1) The filesystem / thin-provision gets corrupted somehow. fs bug,
> hardware, whatever.
> 
> 2) The thin-provision thinks a block is free while the FS thinks it is
> in use. Make it a meta data block so it really matters.
> 
> 3) The thin-provision still has the mapping and data of the block and
> hasn't reused the block yet. On read the device will return the
> correct data as long as the block is not reused. This seems to be a
> valid implementation for a thin-provision device.

That's highly unlikely, actually.  Once you tell the thin-provisioning
device that the block is not in use, they will delete the mapping from
their mapping structures.  So it's highly unlikely you will be able to
recover once you send the TRIM command.

> 4) fsck will find no error but future writes will reuse the block on
> the thin-provision device overwriting the data and causing
> catastrophic FS corruption.

The way this can happen today is if the bitmap block gets corrupted,
and so a block which is in use gets used by another inode.  So now you
have a filesystem block overwritten by a data block from an inode ---
so you have potentially catastrophic FS corruption, even before you
issue the ATA TRIM command.  This can happen to day, and in practice,
it is extremely rare.  So permit me for being highly dubious about
your claim this is going to happen more often with thin-provisioned
devices.

> So I think a fsck pass to check FS used blocks against hardware used
> blocks is essential if the FS does support thin-provisioned devices.

The filesystem might not even know whether or not a thin-provisioned
device is in use.  The OS may not even know whether the device is
thin-provisioned.  So ultiamtely, it's not up to the FS...

		      		       	      - Ted
