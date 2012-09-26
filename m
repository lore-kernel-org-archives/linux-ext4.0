From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Only call update_backups if necessary in online
 resize.
Date: Wed, 26 Sep 2012 11:51:01 +0800
Message-ID: <50627BA5.60106@tao.ma>
References: <1348498817-3598-1-git-send-email-tm@tao.ma> <20120926033935.GD11468@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:51778 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751808Ab2IZDvH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2012 23:51:07 -0400
In-Reply-To: <20120926033935.GD11468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/26/2012 11:39 AM, Theodore Ts'o wrote:
> On Mon, Sep 24, 2012 at 11:00:17PM +0800, Tao Ma wrote:
>> @@ -1355,8 +1356,16 @@ exit_journal:
>>  			int gdb_num;
>>  			gdb_num = group / EXT4_BLOCKS_PER_GROUP(sb);
>>  			gdb_bh = sbi->s_group_desc[gdb_num];
>> -			update_backups(sb, gdb_bh->b_blocknr, gdb_bh->b_data,
>> -				       gdb_bh->b_size);
>> +			/*
>> +			 * only backup the group descriptor block
>> +			 * which hasn't been updated before.
>> +			 */
>> +			if (old_gdb != gdb_bh->b_blocknr) {
>> +				update_backups(sb, gdb_bh->b_blocknr,
>> +					       gdb_bh->b_data,
>> +					       gdb_bh->b_size);
>> +				old_gdb = gdb_bh->b_blocknr;
>> +			}
>>  		}
>>  	}
> 
> Don't we also need to add a call to update_backups() at the end of the
> loop so we update the backup block descriptors for the very last set
> of block groups?
Why?  If it isn't the same as the previous one, it will be updated. If
it is the same, it don't need to be updated. I don't see what your mean
here.

Thanks
Tao
