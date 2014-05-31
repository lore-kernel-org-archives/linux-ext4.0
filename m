From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 13/32] ext3: convert to struct inode_time
Date: Sat, 31 May 2014 16:32:58 +0200
Message-ID: <6394184.hHtXJE2Bp6@wuerfel>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-14-git-send-email-arnd@arndb.de> <53899C95.80806@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
	tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <53899C95.80806@zytor.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Saturday 31 May 2014 02:10:45 H. Peter Anvin wrote:
> On 05/30/2014 01:01 PM, Arnd Bergmann wrote:
> > ext3fs uses unsigned 32-bit seconds for inode timestamps, which will work
> > for the next 92 years, but the VFS uses struct timespec for timestamps,
> > which is only good until 2038 on 32-bit CPUs.
> > 
> > This gets us one small step closer to lifting the VFS limit by using
> > struct inode_time in ext3. The on-disk format limit is lifted in ext4,
> > which will work until 2514.
> > 
> 
> This may be what the spec says, but when I experimented with this just
> now it does seem that both ext2 and ext3 actually interpret timestamps
> as *signed* 32-bit seconds.

Right, I can see that in ext3_iget() now:

        inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);

I may have just looked at ext3_do_update_inode(), which uses this
unsigned conversion:

	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);

and didn't realize that this is only half of the story, and since it
converts from (potentially 64-bit) long to u32, it doesn't matter
whether that is signed or unsigned.

I may have to go through all of them again to see if I made the same
mistake in other file systems as well.

	Arnd
