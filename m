From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] jbd2: Fix block tag checksum verification brokenness
Date: Tue, 28 May 2013 07:34:30 -0400
Message-ID: <20130528113430.GC11839@thunk.org>
References: <20130510233807.GB5706@blackbox.djwong.org>
 <4CE338D9-F69A-4568-AA82-012FEED2E252@dilger.ca>
 <20130513214750.GB8037@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52511 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932878Ab3E1Lef (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 07:34:35 -0400
Content-Disposition: inline
In-Reply-To: <20130513214750.GB8037@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 13, 2013 at 02:47:50PM -0700, Darrick J. Wong wrote:
> Al Viro complained of a ton of bogosity with regards to the jbd2 block tag
> header checksum.  This one checksum is 16 bits, so cut off the upper 16 bits
> and treat it as a 16-bit value and don't mess around with be32* conversions.
> Fortunately metadata checksumming is still "experimental" and not in a shipping
> e2fsprogs, so there should be few users affected by this.
> 
> v2: Eliminate unnecessary variables and make it clear(er) which values are 32
> bits wide.
> 
> v3: Add a comment about why we're only storing half of the crc32c.
> 
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
