From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [Q] ext
Date: Wed, 18 Aug 2010 10:06:59 +0900
Message-ID: <4C6B3233.90007@jp.fujitsu.com>
References: <20100810232321.0eb72247.toshi.okajima@jp.fujitsu.com> <ADCE32D6-3919-45CA-BA50-1BE86583F74D@oracle.com>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50150 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab0HRBGv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Aug 2010 21:06:51 -0400
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o7I16odS022824
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Wed, 18 Aug 2010 10:06:50 +0900
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id EC33145DE4E
	for <linux-ext4@vger.kernel.org>; Wed, 18 Aug 2010 10:06:49 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id CF45D45DD6F
	for <linux-ext4@vger.kernel.org>; Wed, 18 Aug 2010 10:06:49 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id B8A20E08002
	for <linux-ext4@vger.kernel.org>; Wed, 18 Aug 2010 10:06:49 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 75301E08001
	for <linux-ext4@vger.kernel.org>; Wed, 18 Aug 2010 10:06:49 +0900 (JST)
In-Reply-To: <ADCE32D6-3919-45CA-BA50-1BE86583F74D@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

(2010/08/10 15:35), Andreas Dilger wrote:
>
> On 2010-08-10, at 10:23, Toshiyuki Okajima wrote:
<snip>
>> +loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
>> +{
>> +	struct inode *inode = file->f_mapping->host;
>> +	loff_t maxbytes;
>> +
>> +	mutex_lock(&inode->i_mutex);
>> +	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>> +		maxbytes = EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
>> +	else
>> +		maxbytes = inode->i_sb->s_maxbytes;
>
> This part doesn't really have to be under i_mutex.  Otherwise, the patch looks reasonable.
OK.

>
>> +	switch (origin) {
>> +	case SEEK_END:
>> +		offset += inode->i_size;
>> +		break;
>> +	case SEEK_CUR:
>> +		if (offset == 0) {
>> +			mutex_unlock(&inode->i_mutex);
>> +			return file->f_pos;
>> +		}
>> +		offset += file->f_pos;
>> +		break;
>> +       	}
>> +
>> +	if (offset<  0 || offset>  maxbytes) {
>> +		mutex_unlock(&inode->i_mutex);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (offset != file->f_pos) {
>> +		file->f_pos = offset;
>> +		file->f_version = 0;
>> +	}
>> +	mutex_unlock(&inode->i_mutex);
>> +
>> +	return offset;
>> +}
>
> It's too bad that we have to duplicate the whole generic_file_llseek() code here, but I don't think there is a better solution.  However, it is worthwhile to add a comment to this function like:
>
> /* copied from generic_file_llseek() to handle both block-mapped and
>   * extent-mapped maxbytes values.  Should otherwise be identical. */
I understand it.

I apply your comments and then rebuild my patch.
Immediately I'll send it.

Thanks,
Toshiyuki Okajima

