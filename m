From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/3 v2] 285: Test offsets over 4GB
Date: Fri, 31 May 2013 10:41:55 -0500
Message-ID: <51A8C4C3.6040601@redhat.com>
References: <1369948905-6693-1-git-send-email-jack@suse.cz> <1369948905-6693-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab3EaPmD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 11:42:03 -0400
In-Reply-To: <1369948905-6693-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/30/13 4:21 PM, Jan Kara wrote:
> Test whether SEEK_HOLE and SEEK_DATA works correctly with offsets over
> 4GB, 8TB, and 16TB.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks fine

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

fallocate makes ext3 fail for similar reasons, will send a similar patch
to fix that up.

> ---
>  src/seek_sanity_test.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index 748eec2..cd3b1ee 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #define _XOPEN_SOURCE 500
> +#define _FILE_OFFSET_BITS 64
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <sys/vfs.h>
> @@ -125,6 +126,9 @@ static ssize_t do_pwrite(int fd, const void *buf, size_t count, off_t offset)
>  	while (count > written) {
>  		ret = pwrite(fd, buf + written, count - written, offset + written);
>  		if (ret < 0) {
> +			/* Don't warn about too large file. It's fs dependent. */
> +			if (errno == EFBIG)
> +				return ret;
>  			fprintf(stderr, "  ERROR %d: Failed to write %ld "
>  				"bytes\n", errno, (long)count);
>  			return ret;
> @@ -191,6 +195,77 @@ static int do_lseek(int testnum, int subtest, int fd, int filsz, int origin,
>  	return ret;
>  }
>  
> +static int huge_file_test(int fd, int testnum, off_t filsz)
> +{
> +	char *buf = NULL;
> +	int bufsz = alloc_size * 16;	/* XFS seems to round allocated size */
> +	off_t off = filsz - 2*bufsz;
> +	int ret = -1;
> +
> +	buf = do_malloc(bufsz);
> +	if (!buf)
> +		goto out;
> +	memset(buf, 'a', bufsz);
> +
> +	ret = do_pwrite(fd, buf, bufsz, 0);
> +	if (ret)
> +		goto out;
> +	ret = do_pwrite(fd, buf, bufsz, off);
> +	if (ret) {
> +		/*
> +		 * Report success. Filesystem just cannot handle so large
> +		 * offsets and correctly reports it.
> +		 */
> +		if (errno == EFBIG) {
> +			fprintf(stdout, "Test skipped as fs doesn't support so large files.\n");
> +			ret = 0;
> +		}
> +		goto out;
> +	}
> +
> +	/* offset at the beginning */
> +	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, bufsz);
> +	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, bufsz);
> +	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, 0);
> +	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, 1);
> +
> +	/* offset around eof */
> +	ret += do_lseek(testnum,  5, fd, filsz, SEEK_HOLE, off, off + bufsz);
> +	ret += do_lseek(testnum,  6, fd, filsz, SEEK_DATA, off, off);
> +	ret += do_lseek(testnum,  7, fd, filsz, SEEK_DATA, off + 1, off + 1);
> +	ret += do_lseek(testnum,  8, fd, filsz, SEEK_DATA, off - bufsz, off);
> +
> +out:
> +	do_free(buf);
> +	return ret;
> +}
> +
> +/*
> + * Test huge file to check for overflows of block counts due to usage of
> + * 32-bit types.
> + */
> +static int test12(int fd, int testnum)
> +{
> +	return huge_file_test(fd, testnum,
> +				((long long)alloc_size << 32) + (1 << 20));
> +}
> +
> +/*
> + * Test huge file to check for overflows of block counts due to usage of
> + * signed types
> + */
> +static int test11(int fd, int testnum)
> +{
> +	return huge_file_test(fd, testnum,
> +				((long long)alloc_size << 31) + (1 << 20));
> +}
> +
> +/* Test an 8G file to check for offset overflows at 1 << 32 */
> +static int test10(int fd, int testnum)
> +{
> +	return huge_file_test(fd, testnum, 8ULL << 30);
> +}
> +
>  /*
>   * test file with unwritten extents, have both dirty and
>   * writeback pages in page cache.
> @@ -577,6 +652,9 @@ struct testrec seek_tests[] = {
>         {  7, test07, "Test file with unwritten extents, only have dirty pages" },
>         {  8, test08, "Test file with unwritten extents, only have unwritten pages" },
>         {  9, test09, "Test file with unwritten extents, have both dirty && unwritten pages" },
> +       { 10, test10, "Test a huge file for offset overflow" },
> +       { 11, test11, "Test a huge file for block number signed" },
> +       { 12, test12, "Test a huge file for block number overflow" },
>  };
>  
>  static int run_test(struct testrec *tr)
> 

