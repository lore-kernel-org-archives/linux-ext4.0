From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH] e2fsprogs: remove fragment support (V3)
Date: Mon, 13 Aug 2007 00:24:17 +0800
Message-ID: <46BF3431.1070500@suse.de>
References: <46BC9CC3.9090005@suse.de> <20070810184506.GU6689@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36959 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbXHLQXi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Aug 2007 12:23:38 -0400
In-Reply-To: <20070810184506.GU6689@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I should modify the names of these fields, and keep the checking routines.

Andreas Dilger wrote:
> On Aug 11, 2007  01:13 +0800, Coly Li wrote:
>> - --- a/debugfs/set_fields.c
>> +++ b/debugfs/set_fields.c
>> @@ -65,9 +65,7 @@ static struct field_set_info super_fields[] = {
>>  	{ "free_inodes_count", &set_sb.s_free_inodes_count, 4, parse_uint },
>>  	{ "first_data_block", &set_sb.s_first_data_block, 4, parse_uint },
>>  	{ "log_block_size", &set_sb.s_log_block_size, 4, parse_uint },
>> - -	{ "log_frag_size", &set_sb.s_log_frag_size, 4, parse_int },
>>  	{ "blocks_per_group", &set_sb.s_blocks_per_group, 4, parse_uint },
>> - -	{ "frags_per_group", &set_sb.s_frags_per_group, 4, parse_uint },
>>  	{ "inodes_per_group", &set_sb.s_inodes_per_group, 4, parse_uint },
>>  	{ "mtime", &set_sb.s_mtime, 4, parse_time },
>>  	{ "wtime", &set_sb.s_wtime, 4, parse_time },
>> @@ -141,10 +139,7 @@ static struct field_set_info inode_fields[] = {
>>  	{ "generation", &set_inode.i_generation, 4, parse_uint },
>>  	{ "file_acl", &set_inode.i_file_acl, 4, parse_uint },
>>  	{ "dir_acl", &set_inode.i_dir_acl, 4, parse_uint },
>> - -	{ "faddr", &set_inode.i_faddr, 4, parse_uint },
>>  	{ "blocks_hi", &set_inode.osd2.linux2.l_i_blocks_hi, 2, parse_uint },
>> - -	{ "frag", &set_inode.osd2.hurd2.h_i_frag, 1, parse_uint },
>> - -	{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, 1, parse_uint },
>>  	{ "uid_high", &set_inode.osd2.linux2.l_i_uid_high, 2, parse_uint },
>>  	{ "gid_high", &set_inode.osd2.linux2.l_i_gid_high, 2, parse_uint },
>>  	{ "author", &set_inode.osd2.hurd2.h_i_author, 4, parse_uint },
> 
> There should still be some way to set these (now unused) fields, so that
> it is possible to generate failure cases.
> 
>> @@ -293,9 +293,6 @@ static _INLINE_ void expand_inode_expression(char ch,
>>  		time_str = asctime(do_gmt ? gmtime(&t) : localtime(&t));
>>  		printf("%.24s", time_str);
>>  		break;
>> - -	case 'F':
>> - -		printf("%u", inode->i_faddr);
>> - -		break;
> 
> Did you check if @IF is used anywhere else in the problem messages?
> 
>> @@ -497,11 +497,6 @@ void check_super_block(e2fsck_t ctx)
>>  	check_super_value(ctx, "log_block_size", sb->s_log_block_size,
>>  			  MIN_CHECK | MAX_CHECK, 0,
>>  			  EXT2_MAX_BLOCK_LOG_SIZE - EXT2_MIN_BLOCK_LOG_SIZE);
>> - -	check_super_value(ctx, "log_frag_size", sb->s_log_frag_size,
>> - -			  MIN_CHECK | MAX_CHECK, 0, sb->s_log_block_size);
>> - -	check_super_value(ctx, "frags_per_group", sb->s_frags_per_group,
>> - -			  MIN_CHECK | MAX_CHECK, sb->s_blocks_per_group,
>> - -			  bpg_max);
> 
> We may want to keep these checks, as a way to detect corruption.  We
> will never re-use the superblock fields for anything.
> 
> Did you run "make check"?  I'd think some of the test cases depend on
> the superblock output.

Yes, you are right. I do not know the function of "make check" before. There are several failures
from the check.

Also I accept Tso's advice, I will remove the source code piece by piece, other than make it once.

> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 

Thanks and best regards.
