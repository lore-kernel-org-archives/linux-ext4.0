From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC,PATCH 2/2] Direct IO for holes and fallocate
Date: Mon, 17 Aug 2009 20:18:31 -0400
Message-ID: <20090818001831.GB1215@mit.edu>
References: <1249916431.4337.33.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, Curt Wohlgemuth <curtw@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44934 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758338AbZHRASe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Aug 2009 20:18:34 -0400
Content-Disposition: inline
In-Reply-To: <1249916431.4337.33.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's my suggest rewrite of the patch description:

ext4: Direct IO for holes and fallocate: unwritten extents spt for DIO

From: Mingming <cmm@us.ibm.com>

When writing into an unitialized extent via direct I/O, and the direct
I/O doesn't exactly cover the unitialized extent, split the extent
into uninitialized and initialized extents before submitting the I/O.
The reason for doing this is to avoid needing to deal with an ENOSPC
error in the end_io callback that gets used for direct I/O.

Singed-Off-By: Mingming Cao <cmm@us.ibm.com> 
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

------------------


As mentioned in my comments for the previous patch,
ext4_convert_unwritten_extents() needs to be defined in the previous
patch.  This may requiring dragging in substantial portions of this
patch.

The other observation is there seems to be quite a bit of overlap
between ext4_split_unwritten_extents() and
ext4_ext_convert_to_initialized().  Is there some way we can do some
code factorization?

						- Ted
