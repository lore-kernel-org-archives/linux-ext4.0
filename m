From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2 v4] e2fsprogs: Fix how we treat user-spcified filesystem
 size
Date: Thu, 11 Aug 2011 17:02:42 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108111702280.29009@dhcp-27-109.brq.redhat.com>
References: <1307269845-15062-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab1HKPCs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 11:02:48 -0400
In-Reply-To: <1307269845-15062-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 5 Jun 2011, Lukas Czerner wrote:

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

Hi Ted,

any chance merging that ?

Thanks!
-Lukas

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---
> [v2]: do not spell units - mebibytes etc... - but rather use just abbrev.
> [v3]: Change some phrasing in man pages, mainly with the help from Eric Sandeen
> [v4]: Remove 'b' unit designator.
>  lib/e2p/parse_num.c   |    1 -
>  misc/mke2fs.8.in      |   34 ++++++++++++++++++++++++++++------
>  resize/resize2fs.8.in |   23 ++++++++---------------
>  3 files changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/lib/e2p/parse_num.c b/lib/e2p/parse_num.c
> index 83a329a..8e2751b 100644
> --- a/lib/e2p/parse_num.c
> +++ b/lib/e2p/parse_num.c
> @@ -37,7 +37,6 @@ unsigned long long parse_num_blocks2(const char *arg, int log_block_size)
>  		num >>= (1+log_block_size);
>  		break;
>  	case '\0':
> -		break;
>  	default:
>  		return 0;
>  	}
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 4a3b0c3..f315910 100644
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
> @@ -145,10 +145,32 @@ partition.
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
> +parameter may be suffixed by one of the following unit
> +designators: 's', 'K', 'M', 'G', or 'T',
> +for  512 byte sectors, KiB (2^10 Bytes), MiB (2^20 Bytes),
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
> +however it may be restricted in the future. For now, 1024-byte blocks will
> +be assumed in this case, regardless of the filesystem blocksize ultimately
> +chosen by mke2fs.
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
> index e02345d..0f4153c 100644
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
> +parameter may be suffixed by one of the following the unit
> +designators: 's', 'K', 'M', 'G', or 'T',
> +for 512 byte sectors, KiB (2^10 Bytes), MiB (2^20 Bytes),
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
> 

-- 
