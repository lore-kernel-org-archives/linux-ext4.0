From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fallocate creating fragmented files
Date: Wed, 30 Jan 2013 16:43:59 -0500
Message-ID: <20130130214359.GD32724@thunk.org>
References: <1359524809.5789.140661184325217.261ED7C8@webmail.messagingengine.com>
 <5108B833.6010004@redhat.com>
 <1359527713.648.140661184334613.06CF38D4@webmail.messagingengine.com>
 <510942C3.1070503@redhat.com>
 <20130130201412.GA32724@thunk.org>
 <1359580910.30605.140661184656041.31047642@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Bron Gondwana <brong@fastmail.fm>, linux-ext4@vger.kernel.org
To: Robert Mueller <robm@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46259 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab3A3VoE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 16:44:04 -0500
Content-Disposition: inline
In-Reply-To: <1359580910.30605.140661184656041.31047642@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2013 at 08:21:50AM +1100, Robert Mueller wrote:
> 
> For that matter, one big question I have is why each of these results is
> so different.
> 
> [robm@imap14 conf]$ for i in 1 2 3 4 5 6 7 8 9 10; do fallocate -l 20m
> testfile3; filefrag testfile3; /bin/rm testfile3; done

The most likely reason is that it depends on transaction boundaries.
After a block has been released, we can't reuse it until after the
jbd2 transaction which contains the deletion of the inode has
committed.  So even after you've deleted the file, we can't reuse the
blocks right away.  The other thing which will influence the block
allocation is which block group the last allocation was for that
particular file.  So if blocks become available after a commit
completes, if we've started allocating in another block group, we
won't go back to the initial block group.

Cheers,

					- Ted

