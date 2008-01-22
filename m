From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH e2fsprogs] teach libblkid about ext4(dev)
Date: Tue, 22 Jan 2008 18:25:22 -0500
Message-ID: <20080122232522.GF1659@mit.edu>
References: <4796780F.1000603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60044 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbYAVX0B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2008 18:26:01 -0500
Content-Disposition: inline
In-Reply-To: <4796780F.1000603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 22, 2008 at 05:11:11PM -0600, Eric Sandeen wrote:
> Returns ext4dev for now; will need to change to ext4 at the appropriate
> time I guess.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Hmm... see my test_fs patch.  If we decide that this is a good way to
go, then we can use the presence of that flag to cause blkid to return
"ext4dev", and absence of that flag for blkid to return "ext4".

When we rename the kernel filesystem type from ext4dev to ext4, we
also take out the requirement for EXT2_FLAGS_TEST_FILESYS, and simply
tell people to remove that flag from their ext4 filesytems.  Blkid
will then do the right thing without requiring us to synchronize
updating the kernel as well as e2fsprogs at the same time.

What do people think?  I think it's a pretty elegant solution.

	     	       	       		    - Ted
