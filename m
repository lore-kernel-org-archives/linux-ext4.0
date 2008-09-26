From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/3] ext4: Use readahead when reading an inode from the
 inode table
Date: Fri, 26 Sep 2008 08:47:24 -0500
Message-ID: <48DCE7EC.5000801@redhat.com>
References: <1222275213-16268-1-git-send-email-tytso@mit.edu> <1222275213-16268-2-git-send-email-tytso@mit.edu> <1222275213-16268-3-git-send-email-tytso@mit.edu> <20080926082107.GT10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40888 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbYIZNrs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Sep 2008 09:47:48 -0400
In-Reply-To: <20080926082107.GT10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Sep 24, 2008  12:53 -0400, Theodore Ts'o wrote:
>> @@ -514,8 +514,10 @@ static void ext4_put_super(struct super_block *sb)
>> +	if (sbi->s_proc) {
>> +		remove_proc_entry("inode_readahead_bits", sbi->s_proc);
>>  		remove_proc_entry(sb->s_id, ext4_proc_root);
> 
> As a general UI interface, specifying the "bits to shift the filesystem
> block number" seems like an easy-to-implement but is fairly bad from
> a usability point of view.  I'd much prefer to specify this as a
> number of kB to readahead, and it can be converted internally to the
> number of blocks to readahead.  It isn't fatal if we do a bit of rounding
> on the input value to match a full blocksize.

Or specify that it must be a power of two in some range, and reject
other values - either way.

I had the same thought about the nr of bits as a user input value...

-Eric
