From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Mon, 25 Apr 2011 16:40:01 -0600
Message-ID: <4194C4D6-BE86-42CA-BBB4-A8A0E7E94EAC@dilger.ca>
References: <1303762999-20541-1-git-send-email-curtw@google.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, jim@meyering.net, cmm@us.ibm.com,
	hughd@google.com, tytso@mit.edu
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:15807 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab1DYWkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 18:40:04 -0400
In-Reply-To: <1303762999-20541-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-25, at 2:23 PM, Curt Wohlgemuth wrote:
> In the bio completion routine, we should not be setting
> PageUptodate at all -- it's set at sys_write() time, and is
> unaffected by success/failure of the write to disk.
> 
> This can cause a page corruption bug when
> 
>    block size < page size
> 
> @@ -203,46 +203,29 @@ static void ext4_end_bio(struct bio *bio, int error)
> -		/*
> -		 * If this is a partial write which happened to make
> -		 * all buffers uptodate then we can optimize away a
> -		 * bogus readpage() for the next read(). Here we
> -		 * 'discover' whether the page went uptodate as a
> -		 * result of this (potentially partial) write.
> -		 */
> -		if (!partial_write)
> -			SetPageUptodate(page);
> -

I think this is the important part of the code - if there is a read-after-write for a file that was written in "blocksize" units (blocksize < pagesize), does the page get set uptodate when all of the blocks have been written and/or the writing is at EOF?  Otherwise, a read-after-write will always cause data to be fetched from disk needlessly, even though the uptodate information is already in cache.

Cheers, Andreas





