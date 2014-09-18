From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Is ext2 freezable?
Date: Thu, 18 Sep 2014 15:17:36 -0400
Message-ID: <20140918191736.GC19520@thunk.org>
References: <EE124450C0AAF944A40DD71E61F878C99CE2C3@SINEX14MBXC418.southpacific.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dexuan Cui <decui@microsoft.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36189 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaIRTRk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 15:17:40 -0400
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C99CE2C3@SINEX14MBXC418.southpacific.corp.microsoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 18, 2014 at 06:46:21AM +0000, Dexuan Cui wrote:
> 
> I've got the answer:
> ext2.ko itself does support fsfreeze, but typical linux distros don't supply
> ext2.ko at all now -- instead, they usually supply ext3.ko and have ext4 builtin.
> 
> So when I mount an ext2 partition, actually the kernel is registering the ext4
> driver as an ext2 driver and in this case the ext2's s_op->freeze_fs is NULL --
> but, why did ext4 choose this behavior for ext2?

It wasn't a deliberate design choice.  It was just that when
no-journal mode was added to ext4, freeeze support was never
implemented, and up until now, no one had asked for it.  We can add it
to ext4; thanks for calling it to our attention.

Cheers,

					- Ted
