From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2fsck and backup superblocks
Date: Sat, 18 Feb 2012 17:31:31 -0500
Message-ID: <20120218223131.GB8320@thunk.org>
References: <4F3F1439.5000407@ubuntu.com>
 <4F3F1580.9020108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@ubuntu.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37190 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab2BRWbh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Feb 2012 17:31:37 -0500
Content-Disposition: inline
In-Reply-To: <4F3F1580.9020108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 17, 2012 at 07:05:36PM -0800, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 2/17/12 7:00 PM, Phillip Susi wrote:
> > I have noticed that e2fsck always complains about block group descriptor checksums being invalid when run on a backup superblock, even when run again immediately after being told to fix them.  Is there some odd intentional behavior here I'm not aware of?
> 
> Check the list for:
> 
> "[PATCH] libext2fs: quiet spurious group checksum errors"

Which is in e2fsprogs 1.42.1....

       	       	  	       	      	  - Ted
