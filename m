From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: Checking link targets are NULL-terminated
Date: Tue, 9 Dec 2008 18:04:58 +0000
Message-ID: <e9e943910812091004n6cd419e1gc95bad41fb13fb32@mail.gmail.com>
References: <20081205144810.GA25585@dastardly.home.dghda.com>
	 <493E8F31.3040806@panasas.com>
	 <e9e943910812090820h3cc63b5dtb767a8a11ee2bad2@mail.gmail.com>
	 <493EA0E4.10604@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Christoph Hellwig" <hch@infradead.org>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <493EA0E4.10604@panasas.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2008/12/9 Boaz Harrosh <bharrosh@panasas.com>:
> I just want to make sure that you understand the code above and convince
> you that this can/should be done and will damage nothing.

No problem, it never hurts to spell things out in detail :)

> The code you see above is only for links that are shorter then some constant.
> The ext2 (and other fs's) will cache this case and write the symlink directly
> into the inode that will then have 0 number of data blocks. The space allocated
> at inode is constant and is chosen for good inode packing on disk. The inode
> starts empty then if a symlink is short the string is strcpy to above buffer.

Sure, I understand this.

> So even if intentional damage was done to on-disk data, putting another null
> at the end will never hurt. At most it is redundant since there is another
> one preceding. But in the case of damage the damage is fixed. There can never
> be an information lost.

If the link name on disk is corrupted and the last character is not a
zero then it may be changed. That is information lost, albeit probably
not *useful* information. I wouldn't like to make such a change
without an OK from the FS maintainers, but I'll happily do it with
one. So far we seem to have one vote in favour and none against. :)

Note that the corruption doesn't have to be intentional, of course,
although it was in the particular bug report I was looking at
originally.

> For symlinks that are longer then above constant 1 data block is allocated
> and the symlink is written, padded by zeros. This is taken care of by the
> generic layer in the code you patched at fs/namei.c. Terminating at
> i_size + 1 will never reach the disk since only i_size bytes are ever written.

If the data on disk is corrupted such that i_size == PAGE_SIZE then
again we would have different data in-memory and on-disk. However in
this case the page would only contain the link name and so wouldn't be
dirtied and written out unless the name was changed anyway. So I
agree, it should be safe in this case, regardless of my concerns
above.

Thanks,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
