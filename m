From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Date: Fri, 29 Jul 2011 06:19:38 -0700
Message-ID: <20110729131937.GB5910@noexit.corp.google.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com>
 <1302290868.4461.7.camel@mingming-laptop>
 <20110727082730.GG20655@tux1.beaverton.ibm.com>
 <EF1F2330-D8C4-427A-ABB9-D1E607D91A3D@gmail.com>
 <20110728165615.GI20655@tux1.beaverton.ibm.com>
 <20110728220735.GA27253@noexit.corp.google.com>
 <0E795C1D-AD1E-4CC4-9426-2B58D98B14DC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Andreas Dilger <aedilger@gmail.com>,
	Mingming Cao <cmm@us.ibm.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1G2NT6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jul 2011 09:19:58 -0400
Content-Disposition: inline
In-Reply-To: <0E795C1D-AD1E-4CC4-9426-2B58D98B14DC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 29, 2011 at 03:48:45AM -0600, Andreas Dilger wrote:
> On 2011-07-28, at 4:07 PM, Joel Becker wrote:
> > 	We use ethernet crc32 in ocfs2.  btrfs uses crc32c.  Frankly, I
> > could have used crc32c if I'd really thought about the hardware
> > acceleration benefits.  I think it's a good idea for ext4.
> 
> The problem with crc32[c] is that if you don't have hardware acceleration
> it is terribly slow.

	We find ethernet crc32 just fine in ocfs2.  I use the kernel's
implementation, which survives everyone's network traffic, and of course
we added the triggers to jbd2 so we only have to do the calculations on
read and write.

> Yes, it makes sense to just put a "fake" dirent at the end of the leaf block,
> or similar.  I don't think it is necessary to modify existing directories or
> extent blocks to add these structures in, if there is no room, but for new
> blocks, or blocks with space it is enough.

	We have tunefs.ocfs2 code to adjust existing directories to add
the trailer.  It's not too bad, really.
 
Joel

-- 

"People with narrow minds usually have broad tongues."

			http://www.jlbec.org/
			jlbec@evilplan.org
