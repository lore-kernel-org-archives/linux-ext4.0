From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Date: Fri, 8 Apr 2011 13:17:04 -0700
Message-ID: <20110408201703.GC17677@noexit>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com>
 <1302290868.4461.7.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: djwong@us.ibm.com, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:41743 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab1DHURQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 16:17:16 -0400
Content-Disposition: inline
In-Reply-To: <1302290868.4461.7.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 08, 2011 at 12:27:48PM -0700, Mingming Cao wrote:
> We had some discussion about this week at SF (at the ext4 bof at the
> linux colloboration summit). Beyond checksumming the inode itself, it
> would be more useful to checksum the extent indexing blocks, as the ext3
> corruption actually happen at the indirect block.  

	You want to checksum all metadata.  ocfs2 takes advantage of
this because we can just EIO any bad metadata and continue to serve the
rest of the filesystem.

Joel

-- 

"Time is an illusion, lunchtime doubly so."
        -Douglas Adams

			http://www.jlbec.org/
			jlbec@evilplan.org
