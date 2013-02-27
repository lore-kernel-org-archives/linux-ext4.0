From: Dave Jones <davej@redhat.com>
Subject: Re: EXT4 corruption on Linus latest tree.
Date: Wed, 27 Feb 2013 11:04:46 -0500
Message-ID: <20130227160446.GA4792@redhat.com>
References: <20130227154311.GA12450@redhat.com>
 <20130227155539.GA2638@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Borislav Petkov <bp@alien8.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130227155539.GA2638@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 27, 2013 at 04:55:39PM +0100, Borislav Petkov wrote:
 > On Wed, Feb 27, 2013 at 10:43:11AM -0500, Dave Jones wrote:
 > > Built from a pull around midnight EST last night.
 > > (Don't have the git hash, as the source is on the disk that is now inaccessable..)
 > > 
 > > EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
 > > EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
 > > EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235804: block 152052301: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
 > > EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172235381: block 152052288: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
 > > EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #172228609: block 152051744: comm ls: bad entry in directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0, name_len=0
 > > 
 > > This is a 3TB disk which has 1.9TB used.
 > > 
 > > I can see some files/dirs, but some top level dirs now appear empty.
 > > 
 > > About to reboot back to a safe kernel and fsck.
 > 
 > Hmm, more people triggering something like that:
 > http://marc.info/?l=linux-kernel&m=136196926015305&w=2

Yeah, looks similar.  The missing files/dirs reappeared when I
booted an older kernel, so it looks like the corruption doesn't
hit the disk.  Fsck (1.42.5) didn't find anything either.

	Dave
