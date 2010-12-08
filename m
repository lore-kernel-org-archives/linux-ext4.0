From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/2] ext2: speed up file creates by optimizing rec_len functions
Date: Wed, 8 Dec 2010 12:01:51 -0700
Message-ID: <63DB7A38-7D0F-406E-8ACD-9CE5DB977DD9@dilger.ca>
References: <4CFE7347.8030807@redhat.com> <4CFE7409.9090609@redhat.com> <20101207130708.71c894e9.akpm@linux-foundation.org> <4CFEA5AF.2000702@redhat.com> <20101207133308.eb2144da.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63261 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0LHTBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Dec 2010 14:01:52 -0500
In-Reply-To: <20101207133308.eb2144da.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-12-07, at 14:33, Andrew Morton wrote:
> On Tue, 07 Dec 2010 15:22:55 -0600
> Eric Sandeen <sandeen@redhat.com> wrote:
>> Retesting at a bunch of different number-of-files in bonnie
>> (with a small sample size so probably a little noise)
>> 
>> 	|files per sec|
>> files	stock	patched	delta
>> 10,000	12300	14700	+19%
>> 20,000	 6300	 7600	+20%
>> 30,000	 4200	 5000	+20%
>> 40,000	 3150	 3700	+17%
>> 50,000	 2500	 3000	+20%
>> 
>> (again all on a 512MB ramdisk)
>> 
>> *shrug* I'll believe my lyin' eyes, I guess. :)
> 
> I bet other tweaks in there would yield similar goodliness.

I think an important factor here is that this is being tested on a ramdisk, and is likely CPU bound, so any CPU reduction will directly be measured as a performance improvement.  Probably oprofile is in order to see where other major CPU users are.

In the past, ext3_mark_inode_dirty() was a major offender, and I recall that we discussed on the ext4 concall a mechanism to only copy the inode once per transaction so that overhead could be removed.

Cheers, Andreas





