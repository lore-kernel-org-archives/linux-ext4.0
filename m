From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 1/2] fs/ext4: adding and initalizing new members of ext4_inode_info
 and ext4_sb_info
Date: Thu, 03 Oct 2013 17:14:30 -0600
Message-ID: <524DFA56.6000708@hp.com>
References: <1380728219-60784-1-git-send-email-tmac@hp.com> <94F53E8F-6D99-4747-97A9-4FB60DD2BED2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: T Makphaibulchoke <tmac@hp.com>, Theodore Ts'o <tytso@mit.edu>,
	adilger.kernel@dilger.ca,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	aswin@hp.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94F53E8F-6D99-4747-97A9-4FB60DD2BED2@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/03/2013 06:37 PM, Andreas Dilger wrote:
> On 2013-10-02, at 9:36 AM, T Makphaibulchoke wrote:
> 
> What do these additional fields do to the size of struct ext4_inode_info?
> I recall that Ted did a bunch of work to shrink this enough to fit nicely
> into a slab, and it would be a shame to increase the inode size to overflow
> the current packing and increase per-inode memory usage by 25-33%, for an
> improvement that is only noticeable on a 90-core machine.
> 
> Is there another lock that could be shared for this that is unlikely to
> cause much contention?

Thanks for the suggestion.  I was also thinking about this earlier, not sure if it's a good practice.  Looks like it is way better than increasing the inode size.  Will look into this in my rework.
 
> 
> Also, it isn't clear to me why this patch is separate from 2/2, because
> all it does is add fields that are not used for anything.  I don't think
> the 8 lines of code here are so complex that they can't be part of the
> same patch that is actually using them.
> 
> Cheers, Andreas
> 

I was debating whether to combine them into 1 or make them 2 patches.  I'll combine them into one patch in my next submittal.

Thanks,
Mak.
