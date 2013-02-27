From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Wed, 27 Feb 2013 18:01:57 +0100
Message-ID: <20130227170157.GA222@x4>
References: <nsxr4k2kdwv.fsf@closure.thunk.org>
 <20130227124727.GA225@x4>
 <20130227153435.GB5609@thunk.org>
 <20130227154450.GA23402@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130227154450.GA23402@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013.02.27 at 16:44 +0100, Markus Trippelsdorf wrote:
> On 2013.02.27 at 10:34 -0500, Theodore Ts'o wrote:
> > On Wed, Feb 27, 2013 at 01:47:27PM +0100, Markus Trippelsdorf wrote:
> > > Just booted todays Linux tree and got the following errors:
> > > 
> > > ...
> > > Feb 27 13:33:31 x4 kernel: EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: (null)
> > > ...
> > > Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find_dest_de:1657: inode #70647809: block 14164000: comm cupsd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2569822761, rec_len=3837, name_len=1
> > > Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find_dest_de:1657: inode #70911401: block 15213579: comm pdnsd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2000846358, rec_len=36782, name_len=120
> > 
> > Is this reproducible? 

The issue is caused by:

commit d100eef2440fea13e4f09e88b1c8bcbca64beb9f
Author: Zheng Liu <wenqing.lz@taobao.com>
Date:   Mon Feb 18 00:29:59 2013 -0500

    ext4: lookup block mapping in extent status tree

-- 
Markus
