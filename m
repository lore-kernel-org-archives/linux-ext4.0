From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2 v3] e2fsprogs: Fix how we treat user-spcified filesystem
 size
Date: Fri, 20 May 2011 10:44:56 -0500
Message-ID: <4DD68C78.5010403@redhat.com>
References: <1305905808-31093-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@MIT.EDU
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933861Ab1ETPpA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 11:45:00 -0400
In-Reply-To: <1305905808-31093-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/20/11 10:36 AM, Lukas Czerner wrote:
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

Very minor notes below, that I'm sure Ted can probably fix up on the way in.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> [v2]: do not spell units - mebibytes etc... - but rather use just abbrev.
> [v3]: Change some phrasing in man pages, mainly with the help from Eric Sandeen
>  lib/e2p/parse_num.c   |    9 +++++++++
>  misc/mke2fs.8.in      |   37 +++++++++++++++++++++++++++++++------
>  resize/resize2fs.8.in |   23 ++++++++---------------
>  3 files changed, 48 insertions(+), 21 deletions(-)
> 
> diff --git a/lib/e2p/parse_num.c b/lib/e2p/parse_num.c
> index 83a329a..2f1d09d 100644
> --- a/lib/e2p/parse_num.c
> +++ b/lib/e2p/parse_num.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include "e2p.h"
> +#include "../misc/nls-enable.h"
>  
>  #include <stdlib.h>
>  
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
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 4a3b0c3..e685dfb 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -108,7 +108,7 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
>  ]
>  .I device
>  [
> -.I blocks-count
> +.I filesystem-size
>  ]
>  @JDEV@.sp
>  @JDEV@.B "mke2fs \-O journal_dev"
> @@ -136,7 +136,7 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
>  @JDEV@]
>  @JDEV@.I external-journal
>  @JDEV@[
> -@JDEV@.I blocks-count
> +@JDEV@.I filesystem-size
>  @JDEV@]
>  .SH DESCRIPTION
>  .B mke2fs
> @@ -145,10 +145,35 @@ partition.
>  .I device
>  is the special file corresponding to the device (e.g
>  .IR /dev/hdXX ).
> -.I blocks-count
> -is the number of blocks on the device.  If omitted,
> -.B mke2fs
> -automagically figures the file system size.  If called as
> +.I filesystem-size
> +is the size of the filesystem you want to create. Optionally, the
> +.I filesystem-size
> +parameter may be suffixed by one of the following units

very minor nitpick, should probably be "unit designators" - maybe ted can consider that a typo and fix it on the way in :)

> +designators: 'b', 's', 'K', 'M', 'G', or 'T',
> +for filesytem blocks, 512 byte sectors, KiB (2^10 Bytes), MiB (2^20 Bytes),
> +GiB (2^30 Bytes), or TiB (2^40 Bytes) respectively, which are binary (power-of-2),
> +not decimal, units. If no units are specified, then the
> +.I filesystem-size
> +parameter shall specify the number of filesystem blocks.
> +Note that you should not specify
> +.I filesystem-size
> +in block units (or without any units at all) without also specifying block
> +size with the
> +.B \-b
> +option. This will be allowed for now due to compatibility reasons,
> +however it may be restricted in the future.
> +If block size is not specified on the commandline and filesystem-size
> +is specified in block units,
> +1024-byte blocks will be assumed for this purpose, regardless
> +of the filesystem blocksize ultimately chosen by mke2fs.
> +
> +The
> +.I filesystem-size
> +may never be larger than the size of the partition.
> +If the
> +.I filesystem-size
> +parameter is not specified, it will default to the size of the partition.
> +If called as
>  .B mkfs.ext3
>  a journal is created as if the
>  .B \-j
> diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
> index e02345d..2273641 100644
> --- a/resize/resize2fs.8.in
> +++ b/resize/resize2fs.8.in
> @@ -36,29 +36,22 @@ filesystems mounted using ext3 and ext4.).
>  The 
>  .I size
>  parameter specifies the requested new size of the filesystem.
> -If no units are specified, the units of the
> -.I size
> -parameter shall be the filesystem blocksize of the filesystem.
>  Optionally, the 
>  .I size
> -parameter may be suffixed by one of the following the units 
> -designators: 's', 'K', 'M', or 'G',
> -for 512 byte sectors, kilobytes, megabytes, or gigabytes, respectively.
> -The 
> +parameter may be suffixed by one of the following the units

by one of the following unit designators

> +designators: 'b', 's', 'K', 'M', 'G', or 'T',
> +for filesystem blocks, 512 byte sectors, KiB (2^10 Bytes), MiB (2^20 Bytes),
> +GiB (2^30 Bytes), or TiB (2^40 Bytes) respectively, which are binary (power-of-2),
> +not decimal, units.
> +If no units are specified, then the
> +.I size
> +parameter shall specify the number of filesystem blocks. The
>  .I size
>  of the filesystem may never be larger than the size of the partition.
>  If 
>  .I size
>  parameter is not specified, it will default to the size of the partition.
>  .PP
> -Note: when kilobytes is used above, I mean
> -.IR real ,
> -power-of-2 kilobytes, (i.e., 1024 bytes), which some politically correct
> -folks insist should be the stupid-sounding ``kibibytes''.  The same
> -holds true for megabytes, also sometimes known as ``mebibytes'', or
> -gigabytes, as the amazingly silly ``gibibytes''.  Makes you want to
> -gibber, doesn't it?
> -.PP
>  The
>  .B resize2fs
>  program does not manipulate the size of partitions.  If you wish to enlarge

