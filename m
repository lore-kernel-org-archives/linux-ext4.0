From: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Subject: Re: [PATCH -v2]ext4: add the spec for ext4 subdirectory limit(was:Problems
 with the max value for create directory)
Date: Tue, 24 Feb 2009 15:26:44 +0800
Message-ID: <49A3A134.10201@cn.fujitsu.com>
References: <499B9CD3.8060608@cn.fujitsu.com> <20090223032540.GB19739@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62017 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZBXHYt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 02:24:49 -0500
In-Reply-To: <20090223032540.GB19739@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> I really don't think this tweak to Documentation/filesystems/ext4.txt
> is necessary, but if we going to do this, I want to tighten up the
> explanation.
> 
> 						- Ted
> 
I agree.
Thanks.

> ext4: Add fine print for the 32000 subdirectory limit
> 
> Some poeple are reading the ext4 feature list too literally and create
> dubious test cases involving very long filenames and 1k blocksize and
> then complain when they run into an htree-imposed limit.  So add fine
> print to the "fix 32000 subdirectory limit" ext4 feature.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> index cec829b..5c484ae 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -85,7 +85,7 @@ Note: More extensive information for getting started with ext4 can be
>  * extent format more robust in face of on-disk corruption due to magics,
>  * internal redundancy in tree
>  * improved file allocation (multi-block alloc)
> -* fix 32000 subdirectory limit
> +* lift 32000 subdirectory limit imposed by i_links_count[1]
>  * nsec timestamps for mtime, atime, ctime, create time
>  * inode version field on disk (NFSv4, Lustre)
>  * reduced e2fsck time via uninit_bg feature
> @@ -100,6 +100,9 @@ Note: More extensive information for getting started with ext4 can be
>  * efficent new ordered mode in JBD2 and ext4(avoid using buffer head to force
>    the ordering)
>  
> +[1] Filesystems with a block size of 1k may see a limit imposed by the
> +directory hash tree having a maximum depth of two.
> +
>  2.2 Candidate features for future inclusion
>  
>  * Online defrag (patches available but not well tested)
> 
> 
> 

