From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3/ext4 Documentation: remove bh/nobh since it has
 been deprecated
Date: Tue, 07 Jun 2011 09:57:09 -0500
Message-ID: <4DEE3C45.90101@redhat.com>
References: <1307442425-7835-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab1FGO5W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 10:57:22 -0400
In-Reply-To: <1307442425-7835-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/7/11 5:27 AM, Lukas Czerner wrote:
> Bh and nobh mount option has been deprecated in ext4
> (206f7ab4f49a2021fcb8687f25395be77711ddee) and in ext3
> (4c4d3901225518ed1a4c938ba15ba09842a00770)
> so remove those options from documentation.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks Lukas!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Another nice documentation update would be to clearly mark
all defaults in the doc files with (*) (or with values if the
options take them) ...

-Eric

> ---
>  Documentation/filesystems/ext3.txt |    9 ---------
>  Documentation/filesystems/ext4.txt |   23 +++++++----------------
>  2 files changed, 7 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
> index 272f80d..aee5560 100644
> --- a/Documentation/filesystems/ext3.txt
> +++ b/Documentation/filesystems/ext3.txt
> @@ -147,15 +147,6 @@ grpjquota=<file>	during journal replay. They replace the above
>  			package for more details
>  			(http://sourceforge.net/projects/linuxquota).
>  
> -bh		(*)	ext3 associates buffer heads to data pages to
> -nobh			(a) cache disk block mapping information
> -			(b) link pages into transaction to provide
> -			    ordering guarantees.
> -			"bh" option forces use of buffer heads.
> -			"nobh" option tries to avoid associating buffer
> -			heads (supported only for "writeback" mode).
> -
> -
>  Specification
>  =============
>  Ext3 shares all disk implementation with the ext2 filesystem, and adds
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> index 3ae9bc9..232a575 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -68,12 +68,12 @@ Note: More extensive information for getting started with ext4 can be
>      '-o barriers=[0|1]' mount option for both ext3 and ext4 filesystems
>      for a fair comparison.  When tuning ext3 for best benchmark numbers,
>      it is often worthwhile to try changing the data journaling mode; '-o
> -    data=writeback,nobh' can be faster for some workloads.  (Note
> -    however that running mounted with data=writeback can potentially
> -    leave stale data exposed in recently written files in case of an
> -    unclean shutdown, which could be a security exposure in some
> -    situations.)  Configuring the filesystem with a large journal can
> -    also be helpful for metadata-intensive workloads.
> +    data=writeback' can be faster for some workloads.  (Note however that
> +    running mounted with data=writeback can potentially leave stale data
> +    exposed in recently written files in case of an unclean shutdown,
> +    which could be a security exposure in some situations.)  Configuring
> +    the filesystem with a large journal can also be helpful for
> +    metadata-intensive workloads.
>  
>  2. Features
>  ===========
> @@ -272,14 +272,6 @@ grpjquota=<file>	during journal replay. They replace the above
>  			package for more details
>  			(http://sourceforge.net/projects/linuxquota).
>  
> -bh		(*)	ext4 associates buffer heads to data pages to
> -nobh			(a) cache disk block mapping information
> -			(b) link pages into transaction to provide
> -			    ordering guarantees.
> -			"bh" option forces use of buffer heads.
> -			"nobh" option tries to avoid associating buffer
> -			heads (supported only for "writeback" mode).
> -
>  stripe=n		Number of filesystem blocks that mballoc will try
>  			to use for allocation size and alignment. For RAID5/6
>  			systems this should be the number of data
> @@ -393,8 +385,7 @@ dioread_nolock		locking. If the dioread_nolock option is specified
>  			write and convert the extent to initialized after IO
>  			completes. This approach allows ext4 code to avoid
>  			using inode mutex, which improves scalability on high
> -			speed storages. However this does not work with nobh
> -			option and the mount will fail. Nor does it work with
> +			speed storages. However this does not work with
>  			data journaling and dioread_nolock option will be
>  			ignored with kernel warning. Note that dioread_nolock
>  			code path is only used for extent-based files.

