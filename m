From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: avoid arithemetic overflow that can trigger a BUG
Date: Fri, 31 Aug 2018 22:49:36 -0400
Message-ID: <20180901024936.GA27277@thunk.org>
References: <20180831174126.13071-1-tytso@mit.edu>
 <A4D64426-1092-4652-9A8C-EBFD5B7655A7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A4D64426-1092-4652-9A8C-EBFD5B7655A7@dilger.ca>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 31, 2018 at 01:31:05PM -0600, Andreas Dilger wrote:
> > 	map.m_lblk = first_block;
> > -	map.m_len = last_block - first_block + 1;
> > +	len = last_block - first_block + 1;
> > +	map.m_len = (len < UINT_MAX) ? len : UINT_MAX;
> 
> Wouldn't "(len < UINT_MAX)" always be true on a 32-bit system, or is there some
> other limitation in that case (e.g. filesystem < 16TB) that prevents it from
> being an issue?  Otherwise, this should use "unsigned long long len".

first_block and last_block are both 32-bit values and defined as
unsigned long.  That's because they are logical block numbers and
should never be more than 2**32.  The fact that last_block had
overflowed was due to i_size being corrupted to being an insanely
large number.

So it's fine that len is an unsigned long, since first_block and
last_block are both unsigned long.

					- Ted
