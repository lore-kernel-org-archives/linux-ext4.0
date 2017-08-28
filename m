From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Documentation: fix little inconsistencies
Date: Mon, 28 Aug 2017 09:17:07 -0700
Message-ID: <20170828161707.GA4750@magnolia>
References: <20170828094638.GA15378@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        tytso@mit.edu, corbet@lwn.net, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@osdl.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170828094638.GA15378@amd>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 28, 2017 at 11:46:39AM +0200, Pavel Machek wrote:
> Fix little inconsistencies in Documentation: make case and spacing
> match surrounding text, fix ascii-art.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> index 5a8f7f4..75236c0 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -94,10 +94,10 @@ Note: More extensive information for getting started with ext4 can be
>  * ability to pack bitmaps and inode tables into larger virtual groups via the
>    flex_bg feature
>  * large file support
> -* Inode allocation using large virtual block groups via flex_bg
> +* inode allocation using large virtual block groups via flex_bg
>  * delayed allocation
>  * large block (up to pagesize) support
> -* efficient new ordered mode in JBD2 and ext4(avoid using buffer head to force
> +* efficient new ordered mode in JBD2 and ext4 (avoid using buffer head to force
>    the ordering)
>  
>  [1] Filesystems with a block size of 1k may see a limit imposed by the
> @@ -105,7 +105,7 @@ directory hash tree having a maximum depth of two.
>  
>  2.2 Candidate features for future inclusion
>  
> -* Online defrag (patches available but not well tested)
> +* online defrag (patches available but not well tested)
>  * reduced mke2fs time via lazy itable initialization in conjunction with
>    the uninit_bg feature (capability to do this is available in e2fsprogs
>    but a kernel thread to do lazy zeroing of unused inode table blocks
> @@ -602,7 +602,7 @@ Table of Ext4 specific ioctls
>  			      bitmaps and inode table, the userspace tool thus
>  			      just passes the new number of blocks.
>  
> -EXT4_IOC_SWAP_BOOT	      Swap i_blocks and associated attributes
> + EXT4_IOC_SWAP_BOOT	      Swap i_blocks and associated attributes
>  			      (like i_blocks, i_size, i_flags, ...) from
>  			      the specified inode with inode
>  			      EXT4_BOOT_LOADER_INO (#5). This is typically
> diff --git a/Documentation/networking/switchdev.txt b/Documentation/networking/switchdev.txt
> index 5e40e1f..6309e90 100644
> --- a/Documentation/networking/switchdev.txt
> +++ b/Documentation/networking/switchdev.txt
> @@ -29,7 +29,7 @@ with SR-IOV or soft switches, such as OVS, are possible.
>                        sw1p1  +  sw1p3  +  sw1p5  +          eth1
>                          +    |    +    |    +    |            +
>                          |    |    |    |    |    |            |
> -                     +--+----+----+----+-+--+----+---+  +-----+-----+
> +                     +--+----+----+----+----+----+---+  +-----+-----+

Except for this last part, looks ok.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>                       |         Switch driver         |  |    mgmt   |
>                       |        (this document)        |  |   driver  |
>                       |                               |  |           |
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


