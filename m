From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Tue, 06 Feb 2007 21:45:37 -0600
Message-ID: <45C94B61.4070105@redhat.com>
References: <20070116210520sho@rifu.tnes.nec.co.jp> <20070206173344.a3e8e37a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sho@tnes.nec.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965628AbXBGDps (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Feb 2007 22:45:48 -0500
In-Reply-To: <20070206173344.a3e8e37a.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Tue, 16 Jan 2007 21:05:20 +0900
> sho@tnes.nec.co.jp wrote:

...

>> +ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
>> +			pgoff_t from_page,  pgoff_t dest_from_page,
>> +			pgoff_t count_page, unsigned long *delete_start) 
>> +{
>> +	struct ext4_ext_path *org_path = NULL;
>> +	struct ext4_ext_path *dest_path = NULL;
>> +	struct ext4_extent   *oext, *dext;
>> +	struct ext4_extent   tmp_ext;
>> +	int	err = 0;
>> +	int	depth;
>> +	unsigned long from, count, dest_off, diff, replaced_count = 0;
> 
> These should be sector_t, shouldn't they?

At some point should we start using blkcnt_t properly? 
(block-in[-large]-file, not block-in[-large]-device?)  I think that's 
what it was introduced for, although it's not in wide use at this point.

I guess the type really isn't used anywhere else; just in the inode's 
i_blocks.  Hmm.

-Eric
