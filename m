From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v3] e2fsprogs: Fix how we treat user-spcified
 filesystem size
Date: Tue, 31 May 2011 19:45:17 -0400
Message-ID: <20110531234517.GA2629@thunk.org>
References: <1305905808-31093-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36902 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161008Ab1FACW0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 May 2011 22:22:26 -0400
Content-Disposition: inline
In-Reply-To: <1305905808-31093-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 20, 2011 at 05:36:47PM +0200, Lukas Czerner wrote:
> mke2fs and resize2fs allows specifying filesystem size as a parameter,
> former called as blocks-count. However it has been a little bit messy so
> this commit fixes it mainly by updating man pages.
> 
> We can not specify filesystem size in blocks count without specifying
> blocksize as well. It is because we need blocks count to determine
> filesystem type, and we need filesystem type to determine blocksize. So
> it should not be allowed, however due to compatibility reason it should
> be still possible, so at least print warning message for now, so we can
> easily restrict that later.
> 
> Filesystem size can be specified using units as suffixes. This was not
> documented for mke2fs, so this commits adds proper documentation into
> mke2fs man page.
> 
> For the sake of completeness add 'b' (filesystem blocks) unit.

I'd much rather fix this by documenting that without a suffix, it will
be interpreted as the number of blocks if -b is specified, and that if
-b is not specified, it will be interpreted as kilobytes (but that
this usage is deprecated).

> @@ -37,6 +38,14 @@ unsigned long long parse_num_blocks2(const char *arg, int log_block_size)
>  		num >>= (1+log_block_size);
>  		break;
>  	case '\0':
> +	case 'b':
> +		if (!log_block_size) {
> +			fprintf(stderr,
> +				_("Warning: You should not specify filesystem "
> +				"size without specifying block size '-b'. "
> +				"Will assume 1024 byte blocks!\n"
> +				));
> +		}
>  		break;
>  	default:
>  		return 0;

I'd much rather not add this, since there may be other programs using
parse_num_blocks2() that aren't mke2fs or tune2fs, where -b doesn't
make sense.

							- Ted
