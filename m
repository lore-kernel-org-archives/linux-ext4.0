From: djwong <djwong@us.ibm.com>
Subject: Re: [RFC] jbd2: reduce the number of writes when commiting a
 transacation
Date: Mon, 23 Apr 2012 22:19:48 +0000
Message-ID: <20120423221948.GA6938@tux1.beaverton.ibm.com>
References: <20120420110627.GA30373@gmail.com>
 <E5D2F131-A01C-4CB2-8A7C-88CACBBC450B@dilger.ca>
 <20120423022505.GA7855@gmail.com>
 <67060CC0-9F64-40ED-9467-572996ECF21F@whamcloud.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:39987 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2DWWUO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Apr 2012 18:20:14 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 23 Apr 2012 16:20:12 -0600
Content-Disposition: inline
In-Reply-To: <67060CC0-9F64-40ED-9467-572996ECF21F@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 23, 2012 at 01:24:39AM -0500, Andreas Dilger wrote:
> On 2012-04-22, at 21:25, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> 
> > On Fri, Apr 20, 2012 at 05:21:59AM -0600, Andreas Dilger wrote:
> >> 
> >> 
> >> The reason that there are two separate writes is because if the write
> >> of the commit block is reordered before the journal data, and only the
> >> commit block is written before a crash (data is lost), then the journal
> >> replay code may incorrectly think that the transaction is complete and
> >> copy the unwritten (garbage) block to the wrong place.
> >> 
> >> I think there is potentially an existing solution to this problem,
> >> which is the async journal commit feature.  It adds checksums to the
> >> journal commit block, which allows verifying that all blocks were
> >> written to disk properly even if the commit block is submitted at
> >> the same time as the journal data blocks.
> >> 
> >> One problem with this implementation is that if an intermediate
> >> journal commit has a data corruption (i.e. checksum of all data
> >> blocks does not match the commit block), then it is not possible
> >> to know which block(s) contain bad data.  After that, potentially
> >> many thousands of other operations may be lost.
> >> 
> >> We discussed a scheme to store a separate checksum for each block
> >> in a transaction, by storing a 16-bit checksum (likely the low
> >> 16 bits of CRC32c) into the high flags word for each block.  Then,
> >> if one or more blocks is corrupted, it is possible to skip replay
> >> of just those blocks, and potentially they will even be overwritten
> >> by blocks in a later transaction, requiring no e2fsck at all.
> > 
> > Thanks for pointing out this feature.  I have evaluated this feature in my
> > benchmark, and it can dramatically improve the performance. :-)
> > 
> > BTW, out of curiosity, why not set this feature on default?
> 
> As mentioned previously, one drawback of depending on the checksums for
> transaction commit is that if one block in and of the older transactions is
> bad, then this will cause the bad block's transaction to be aborted, along
> with all of the later transactions.
> 
> By skipping the replay of many transactions after reboot (some of which may
> have already written to the filesystem before the crash) this may leave the
> filesystem in a very inconsistent state. 
> 
> A better solution. (which has been discussed, but not implemented yet) is to
> write the checksum for each block in the transaction, and only skip restoring
> the block(s) with a good checksum in an otherwise complete transaction. 
> 
> This would need to change the journal disk format, but might be a good time
> to do this with Darrick's other checksum patches. 

My huge checksum patchset _does_ include checksums for data blocks; see the
t_checksum field in struct journal_block_tag_s.  iirc the corresponding journal
replay modifications will skip over corrupt data blocks and keep going.

--D
> 
> Cheers, Andreas--
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

