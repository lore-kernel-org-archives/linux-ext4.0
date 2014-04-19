From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data journalling
 mode
Date: Sat, 19 Apr 2014 11:40:35 +0900
Message-ID: <000b01cf5b78$bde469e0$39ad3da0$@samsung.com>
References: <002a01cf59c3$4eaf7490$ec0e5db0$@samsung.com>
 <alpine.LFD.2.00.1404171051040.2143@localhost.localdomain>
 <008501cf5a2b$14b6c690$3e2453b0$@samsung.com>
 <alpine.LFD.2.00.1404171259130.2143@localhost.localdomain>
 <009001cf5a34$c1b68fc0$4523af40$@samsung.com>
 <alpine.LFD.2.00.1404171412090.2143@localhost.localdomain>
 <001101cf5aa7$49718b50$dc54a1f0$@samsung.com>
 <20140418143711.GA19131@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>,
	'Jan Kara' <jack@suse.cz>,
	'linux-ext4' <linux-ext4@vger.kernel.org>
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:50111 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaDSCkh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Apr 2014 22:40:37 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4900JO9BFOPCB0@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Sat, 19 Apr 2014 11:40:36 +0900 (KST)
In-reply-to: <20140418143711.GA19131@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> So a couple of things.  First of all, ext4_force_commit() is a very
> expensive call, so calling it twice is really not a good idea.
Yes, Right.
> 
> Secondly, in the ext4_collapse_range() you are calling
> ext4_force_commit() before filemap_write_and_wait_range().
> 
> 	/* Call ext4_force_commit to flush all data in case of data=journal. */
> 	if (ext4_should_journal_data(inode)) {
> 		ret = ext4_force_commit(inode->i_sb);
> 		if (ret)
> 			return ret;
> 	}
> 
> 	/* Write out all dirty pages */
> 	ret = filemap_write_and_wait_range(inode->i_mapping, offset, -1);
> 	if (ret)
> 		return ret;
> 
> Shouldn't we reverse these two calls?
Yes, The original problem will occur again if we reverse these calls.
ext4_force_commit will mark the buffers as dirty during commit transcation.
So we should sync it using filemap_write_and_wait_range later.
> 
> Finally, I'm wondering if we would be better off creating a new
> explicit EXT4_I(inode)->i_write_mutex which is used to block new
> writes from starting.  This could also be used to subsume the
> ext4_aio_mutex.
Right. It is better method. I will check your point. :)

Thanks Ted!!
> 
> 						- Ted

