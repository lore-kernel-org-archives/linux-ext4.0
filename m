From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/3] generic/004: fix filtering of expected error message
Date: Sat, 12 Apr 2014 23:06:04 -0500
Message-ID: <534A0D2C.409@sandeen.net>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu> <1397343317-14669-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35357 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaDMEGH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 00:06:07 -0400
In-Reply-To: <1397343317-14669-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/12/14, 5:55 PM, Theodore Ts'o wrote:
> The failure message goes to stderr, so we need to redirect stderr to
> stdout before running sed.

Heh, whoops.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  tests/generic/004     | 2 +-
>  tests/generic/004.out | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/004 b/tests/generic/004
> index 406c29e..23ca349 100755
> --- a/tests/generic/004
> +++ b/tests/generic/004
> @@ -58,7 +58,7 @@ $XFS_IO_PROG -T \
>  rm ${testfile}
>  
>  # test creating a r/o tmpfile.  Should fail
> -$XFS_IO_PROG -Tr ${TEST_DIR} -c "close" | _filter_test_dir
> +$XFS_IO_PROG -Tr ${TEST_DIR} -c "close" 2>&1 | _filter_test_dir
>  
>  # success, all done
>  status=0
> diff --git a/tests/generic/004.out b/tests/generic/004.out
> index b85c11c..527b2c2 100644
> --- a/tests/generic/004.out
> +++ b/tests/generic/004.out
> @@ -3,4 +3,4 @@ wrote 4096/4096 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  read 4096/4096 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -/mnt/test: Invalid argument
> +TEST_DIR: Invalid argument
> 

