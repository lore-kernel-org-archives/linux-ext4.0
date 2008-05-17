From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sat, 17 May 2008 11:59:58 -0600
Message-ID: <20080517175958.GL3491@webber.adilger.int>
References: <482DDA56.6000301@redhat.com>
 <20080516130545.845a3be9.akpm@linux-foundation.org>
 <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org>
 <482E08E6.4030507@redhat.com> <20080516225304.GG15334@shareable.org>
 <20080517002030.GA7374@mit.edu>
 <20080516173552.e88183d9.akpm@linux-foundation.org>
 <20080517134344.GA7411@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vge
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54412 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYEQSAJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 May 2008 14:00:09 -0400
In-reply-to: <20080517134344.GA7411@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 17, 2008  09:43 -0400, Theodore Ts'o wrote:
> On Fri, May 16, 2008 at 05:35:52PM -0700, Andrew Morton wrote:
> > Journal wrapping could cause the commit block to get written before its
> > data blocks.  We could improve that by changing the journal layout a bit:
> > wrap the entire commit rather than just its tail.  Such a change might
> > be intrusive though.
> 
> Or we backport jbd2's checksum support in the commit block to jbd;
> with the checksum support, if the commit block is written out-of-order
> with the rest of the blocks in the commit, the commit will simply not
> be recognized as valid, and we'll use the previous commit block as the
> last valid commit.

The jbd2 journal checksum support, along with the 64-bit journal block
layout is designed to be 100% compatible with jbd, so it would be
trivial to "back port" jbd2.  Just copy jbd2 into jbd, and add the
option to set (or set by default) the JBD_FEATURE_COMPAT_CHECKSUM
feature in the journal.

I was going to suggest complete removal of jbd2 at that point, but
the ordered-mode rewrite is still pending and should live in ext4
for a reasonably long while before going back to ext3.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

