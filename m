From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [ext2] Mislabeled quadratic probing?
Date: Sat, 29 Jul 2017 19:37:18 -0700
Message-ID: <20170730023718.GH15980@bombadil.infradead.org>
References: <07c8955b-0ead-9dd9-978e-767d5dec6712@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, jack@suse.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Sean Anderson <seanga2@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <07c8955b-0ead-9dd9-978e-767d5dec6712@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 29, 2017 at 10:24:29AM -0400, Sean Anderson wrote:
> Hi,
> 
> I was reading through the ext2 inode allocation code, and found the
> following snippet in fs/ext2/ialloc.c:find_group_other
> 
> /*
>  * Use a quadratic hash to find a group with a free inode and some
>  * free blocks.
>  */
> for (i = 1; i < ngroups; i <<= 1) {
>         group += i;
>         if (group >= ngroups)
>                 group -= ngroups;
>         desc = ext2_get_group_desc (sb, group, NULL);
>         if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
>                         le16_to_cpu(desc->bg_free_blocks_count))
>                 goto found;
> }
> 
> As I understand it, quadratic probing starting at a hash H would try
> positions H+1, H+4, H+9, H+16, H+25, etc. Here, however, the algorithm
> appears to try positions H+1, H+3, H+7, H+15, H+31, etc., which appears
> to be some form of exponential probing. I was unable to find the patch
> which introduced this code, but it appears that it was introduced in
> v2.4.14.3, and before that linear probing was used. Clearly, this code
> works, and I can't really find any compelling arguments to switch to
> quadratic probing proper. I suspect it was done this way to avoid a
> multiply or an extra subtract on every loop. Can anyone shed some light
> on the choice (and apparent mislabel) of this algorithm?

It can't have been to avoid an arithmetic operation.  The quadratic
hash would simply be s/<<= 1/+= 2/ which is going to be equal cost on
basically every CPU.

The biggest danger I see here is that we're only going to test 32
groups before falling back to linear probing (we'll shift the single
'1' bit out of 'i' in 32 steps).  That might be a performance problem,
but it should hit quite rarely.

The danger in changing it is that we'll end up with new files created in
a directory choosing a different block group from files created in that
directory using an old kernel.  And that could be a worse performance
impact.

I think we'd need to see some benchmarks ... Ted, any suggestions for
something which might show a difference between these two approaches
to hashing?
