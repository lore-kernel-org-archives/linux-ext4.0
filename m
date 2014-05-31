From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC 13/32] ext3: convert to struct inode_time
Date: Sat, 31 May 2014 02:10:45 -0700
Message-ID: <53899C95.80806@zytor.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-14-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
	john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
	geert@linux-m68k.org, lftan@altera.com,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1401480116-1973111-14-git-send-email-arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05/30/2014 01:01 PM, Arnd Bergmann wrote:
> ext3fs uses unsigned 32-bit seconds for inode timestamps, which will work
> for the next 92 years, but the VFS uses struct timespec for timestamps,
> which is only good until 2038 on 32-bit CPUs.
> 
> This gets us one small step closer to lifting the VFS limit by using
> struct inode_time in ext3. The on-disk format limit is lifted in ext4,
> which will work until 2514.
> 

This may be what the spec says, but when I experimented with this just
now it does seem that both ext2 and ext3 actually interpret timestamps
as *signed* 32-bit seconds.

	-hpa

