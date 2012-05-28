From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] ext4: force ro mount if ext4_setup_super() fails
Date: Mon, 28 May 2012 13:53:16 -0400
Message-ID: <20120528175316.GJ19152@thunk.org>
References: <4FBE693F.6090705@redhat.com>
 <4FBE6977.5040604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46031 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab2E1RxT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 13:53:19 -0400
Content-Disposition: inline
In-Reply-To: <4FBE6977.5040604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 24, 2012 at 12:01:43PM -0500, Eric Sandeen wrote:
> If ext4_setup_super() fails i.e. due to a too-high revision,
> the error is logged in dmesg but the fs is not mounted RO as
> indicated.
> 
> Tested by:
> 
> # mkfs.ext4 -r 4 /dev/sdb6
> # mount /dev/sdb6 /mnt/test
> # dmesg | grep "too high"
> [164919.759248] EXT4-fs (sdb6): revision level too high, forcing read-only mode
> # grep sdb6 /proc/mounts
> /dev/sdb6 /mnt/test2 ext4 rw,seclabel,relatime,data=ordered 0 0
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
