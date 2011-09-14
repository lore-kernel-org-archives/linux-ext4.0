From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] libext2fs: add new test: tst_inode_size
Date: Wed, 14 Sep 2011 14:47:08 -0600
Message-ID: <0E958708-A440-43C9-B69F-4E677AB82580@dilger.ca>
References: <1316020593-19050-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:12700 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab1INUrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2011 16:47:10 -0400
In-Reply-To: <1316020593-19050-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-14, at 11:16 AM, Theodore Ts'o wrote:
> This test makes sure the size of the ext2_inode is what we expect
> 
> +#define offsetof(type, member)  __builtin_offsetof (type, member)
> +#define check_field(x) cur_offset = do_field(#x, sizeof(inode.x),	\
> +				offsetof(struct ext2_inode, x), \
> +				cur_offset)

One thing I noticed with this check_field() macro is that it doesn't
actually detect the case if the size of a field is changed.  This hit
me when I was making a cleanup to the large journal patch which renamed
s_jnl_blocks[15] to s_jnl_size_lo and s_jnl_blocks[16] to s_jnl_size_hi
for clarity.  The tst_super_size test passed just fine, but the e2fsck
test scripts failed in weird and wonderful ways.

A better solution might be to explicitly pass the expected field size
instead of getting both the size and offset from the structure itself.
Since these structures change very rarely it isn't much maintenance,
but it would be lousy if code was released that had some incorrect
field offset because someone increased or decreased an earlier field
without thinking enough, and those fields weren't used in normal tests.

I can submit a patch if you are interested.

> +static int do_field(const char *field, size_t size, int offset, int cur_offset)
> +{
> +	if (offset != cur_offset) {
> +		printf("Warning!  Unexpected offset at %s\n", field);
> +		exit(1);
> +	}
> +	printf("%8d %-30s %3u\n", offset, field, (unsigned) size);
> +	return offset + size;
> +}
> +
> +void check_structure_fields()
> +{
> +#if (__GNUC__ >= 4)
> +	int cur_offset = 0;
> +
> +	printf("%8s %-30s %3s\n", "offset", "field", "size");
> +	check_field(i_mode);
> +	check_field(i_uid);
> +	check_field(i_size);
> +	check_field(i_atime);
> +	check_field(i_ctime);
> +	check_field(i_mtime);
> +	check_field(i_dtime);
> +	check_field(i_gid);
> +	check_field(i_links_count);
> +	check_field(i_blocks);
> +	check_field(i_flags);
> +	check_field(osd1.linux1.l_i_version);
> +	check_field(i_block);
> +	check_field(i_generation);
> +	check_field(i_file_acl);
> +	check_field(i_size_high);
> +	check_field(i_faddr);
> +	check_field(osd2.linux2.l_i_blocks_hi);
> +	check_field(osd2.linux2.l_i_file_acl_high);
> +	check_field(osd2.linux2.l_i_uid_high);
> +	check_field(osd2.linux2.l_i_gid_high);
> +	check_field(osd2.linux2.l_i_reserved2);
> +	printf("Ending offset is %d\n\n", cur_offset);
> +#endif
> +}
> +
> +
> +int main(int argc, char **argv)
> +{
> +	int l = sizeof(struct ext2_inode);
> +
> +	check_structure_fields();
> +	printf("Size of struct ext2_inode is %d\n", l);
> +	if (l != 256) {
> +		exit(1);
> +	}
> +	exit(0);
> +}
> -- 
> 1.7.4.1.22.gec8e1.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





