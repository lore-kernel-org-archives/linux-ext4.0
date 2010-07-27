From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't print scary messages for allocation
 failures post-abort
Date: Tue, 27 Jul 2010 09:56:16 -0400
Message-ID: <20100727135616.GF18966@thunk.org>
References: <4C4DE314.6030100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60293 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab0G0N4L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 09:56:11 -0400
Content-Disposition: inline
In-Reply-To: <4C4DE314.6030100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 26, 2010 at 02:33:40PM -0500, Eric Sandeen wrote:
> I often get emails containing the "This should not happen!!" message,
> conveniently trimmed to remove things like:
> 
> sd 0:0:0:0: [sda] Unhandled error code
> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 03 13 c9 70 00 00 28 00
> end_request: I/O error, dev sda, sector 51628400
> Aborting journal on device dm-0-8.
> EXT4-fs error (device dm-0): ext4_journal_start_sb: Detected aborted journal
> EXT4-fs (dm-0): Remounting filesystem read-only
> 
> I don't think there is any value to the verbosity if the reason is
> due to a filesystem abort; it just obfuscates the root cause.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I've added this patch to the ext4 patch queue, thanks.

     	   	      	     	  	- Ted
