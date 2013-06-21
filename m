From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] ext2: Reduce object size when !CONFIG_PRINTK
Date: Fri, 21 Jun 2013 10:06:23 -0700
Message-ID: <1371834383.19215.44.camel@joe-AO722>
References: <2e70d518b9f6b8eea33c01a36983a1ccb1839282.1371575536.git.joe@perches.com>
	 <20130621165049.GP13932@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-kernel@vger.kernel.org,
	linux-embedded <linux-embedded@vger.kernel.org>,
	openwrt-hackers@openwrt.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130621165049.GP13932@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2013-06-21 at 18:50 +0200, Jan Kara wrote:
> On Tue 18-06-13 10:14:39, Joe Perches wrote:
> > Reducing the object size ~5kb/15% could be useful for embedded
> > systems.
> > 
> > Add #ifdef CONFIG_PRINTK #else #endif blocks
> > to hold formats and arguments, passing " " to
> > functions when !CONFIG_PRINTK and still verifying
> > format and arguments with no_printk.
> > 
> >  $ size fs/ext2/built-in.o*
> >     text   data	    bss	    dec	    hex	filename
> >    31297     44	      4	  31345	   7a71	fs/ext2/built-in.o.ext2.new
> >    36288     44	      4	  36336	   8df0	fs/ext2/built-in.o.ext2.old
> > 
> >  $ grep -E "CONFIG_EXT2|CONFIG_PRINTK" .config
> >  # CONFIG_PRINTK is not set
> >  CONFIG_EXT2_FS=y
> >  # CONFIG_EXT2_FS_XATTR is not set
> >  # CONFIG_EXT2_FS_XIP is not set
>   I'm somewhat reluctant to merge this unless I know someone really
> cares. It looks a bit ugly to ifdef every function doing some printing just
> to reduce object size when CONFIG_PRINTK is disabled... And in future LTO
> might help us ;)

(adding cc's to linux-embedded and openwrt
 maybe someone there cares)

Link time optimization might help some, but these calls
are still made and the strings could not be eliminated
without this.

Original patch: http://patchwork.kernel.org/patch/2744401/
