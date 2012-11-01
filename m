From: "George Spelvin" <linux@horizon.com>
Subject: Re: ext4: fix metadata checksum calculation for the superblock
Date: 1 Nov 2012 03:28:47 -0400
Message-ID: <20121101072847.25732.qmail@science.horizon.com>
References: <20121101071818.GG19576@blackbox.djwong.org>
Cc: linux-ext4@vger.kernel.org, tm@tao.ma, tytso@mit.edu
To: darrick.wong@oracle.com, linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:16820 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753568Ab2KAH2s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2012 03:28:48 -0400
In-Reply-To: <20121101071818.GG19576@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Oh, so ... it's just nfsd that causes the linear fallback?  Regular (i.e.
> non-nfs) users can see everything in the dir, no error messages?

Yup.  After it survived one e2fsck -D, I poked at the directory a bit
to see if I could cause the error.  No success from local access.

It's also probably an NFSv2 client.  I wonder if it's doing something
odd with directory seeks that's causing problems; perhaps htree and the
32-bit seek cookie limit are not friends?

>> I haven't observed it, no.  But the nature of the symptoms suggests it
>> might be happening.

> Hum.  When linear scan happens on a hashed dir, it's scanning the same
> blocks that the hash scan sees.   The htree block looks like a regular
> directory block with one huge "unused" dirent that wraps all the htree
> data.  So, the linear scan should find the exact same files as a htree
> scan would.  If it doesn't, something's wrong.  But you say it isn't,
> so I imagine it's fine.

Maybe I was wrong.  I was worried that it was aborting the directory
scan due to the error and thus files would disappear.  If that doesn't
happen, no worries.
