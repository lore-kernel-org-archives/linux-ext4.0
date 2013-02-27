From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 corruption on Linus latest tree.
Date: Wed, 27 Feb 2013 11:44:17 -0500
Message-ID: <20130227164417.GF5609@thunk.org>
References: <20130227154311.GA12450@redhat.com>
 <20130227155539.GA2638@pd.tnic>
 <20130227160446.GA4792@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130227160446.GA4792@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 27, 2013 at 11:04:46AM -0500, Dave Jones wrote:
>  > > EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
> 
> Yeah, looks similar.  The missing files/dirs reappeared when I
> booted an older kernel, so it looks like the corruption doesn't
> hit the disk.  Fsck (1.42.5) didn't find anything either.

I suspect I see the problem...   can you send me the results of 

  debugfs -R "stat <172235804>" /dev/sdb1

to confirm?

Thanks,

						- Ted
