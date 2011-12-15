From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v2 4/7] VFS: Rename and refactor writeback_inodes_sb_if_idle
Date: Thu, 15 Dec 2011 15:10:29 +0800
Message-ID: <4EE99D65.3060302@cn.fujitsu.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com> <1323367477-21685-5-git-send-email-kamal@canonical.com> <4EE6C7AD.3020907@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Kamal Mostafa <kamal@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab1LOHL0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Dec 2011 02:11:26 -0500
In-Reply-To: <4EE6C7AD.3020907@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ping...

On tue, 13 Dec 2011 11:34:05 +0800, Miao Xie wrote:
> On thu, 8 Dec 2011 10:04:34 -0800, Kamal Mostafa wrote:
>>  /**
>> - * writeback_inodes_sb_if_idle	-	start writeback if none underway
>> + * try_to_writeback_inodes_sb_nr	-	start writeback if none underway
>>   * @sb: the superblock
>>   * @nr: the number of pages to write
>>   *
>>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>>   * Returns 1 if writeback was started, 0 if not.
>>   */
>> -int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
>> +int try_to_writeback_inodes_sb_nr(struct super_block *sb,
>>  				   unsigned long nr,
>>  				   enum wb_reason reason)
>>  {
>>  	if (!writeback_in_progress(sb->s_bdi)) {
>>  		down_read(&sb->s_umount);
>> -		writeback_inodes_sb_nr(sb, nr, reason);
>> +		if (nr == 0)
>> +			writeback_inodes_sb(sb, reason);
>> +		else
>> +			writeback_inodes_sb_nr(sb, nr, reason);
>>  		up_read(&sb->s_umount);
>>  		return 1;
>>  	} else
>>  		return 0;
> 
> The comment said "Returns 1 if writeback was started", so if writeback_in_progress()
> return true, I think this function also should return 1.
> 
> BTW: Does anyone know when this patchset will be merged into the main tree?
> 
> Thanks
> Miao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

