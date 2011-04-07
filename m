From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH 1/2] ext4: Calculate and verify inode checksums
Date: Thu, 07 Apr 2011 10:10:52 -0700
Message-ID: <4D9DF01C.6050506@oracle.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <20110406224547.GT32706@tux1.beaverton.ibm.com> <4D9D0ADB.9010005@oracle.com> <20110407164006.GC24354@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Joel Becker <jlbec@evilplan.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:40605 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab1DGRLL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Apr 2011 13:11:11 -0400
In-Reply-To: <20110407164006.GC24354@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/07/2011 09:40 AM, Darrick J. Wong wrote:
> Yes, I see that jbd2 has triggers, looks like a nifty feature.  I suppose if I
> went with that approach I'd still have to calculate the checksum in
> ext4_do_update_inode in the nojournal case, and in the journal case I'd write a
> trigger that would figure out which inodes in a given buffer are actually dirty
> and compute their checksums.

Yes, you could use a in-mem flag (set in update, cleared in trigger) to
identify dirty inodes. The discussion on stable pages could be relevant for
the nojournal case.

>
> That said, I haven't really quantified the performance impact of this naive
> approach yet, so I wonder -- did you see a similar scenario with ocfs2, and
> what kind of performance increase did you get by adapting the code to use the
> jbd2 trigger?  If there's potentially a large increase, it would be interesting
> to apply the same conversion to the group descriptor checksumming code too.

Joel Becker may remember the overhead. He wrote the patch. That said we have few
differences. ocfs2 has larger (blocksized) inodes. Also, it computes ECC. The code
is in fs/ocfs2/blockcheck.c.

As in, you may want to generate ext4 specific numbers.
