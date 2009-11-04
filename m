From: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Subject: Re: ext4_fiemap gives 0 extents for files smaller than a block
 (patch included)
Date: Wed, 04 Nov 2009 22:44:10 +0100
Message-ID: <1257371050.13852.28.camel@michlmayr>
References: <1257360161.22057.16.camel@michlmayr>
	 <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932753AbZKDVoN@vger.kernel.org>
In-Reply-To: <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thank you for your reply.

> >
> > @@ -3700,7 +3701,8 @@
> >  		start_blk = start >> inode->i_sb->s_blocksize_bits;
> > -		len_blks = len >> inode->i_sb->s_blocksize_bits;
> > +		end_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
> > +		len_blks = end_blk - start_blk + 1;
> 
> I don't think this is quite correct either.  For example, if blocksize  
> is 1024
> and start is 1023 (start_blk = 0) and len is 2 (end = 1024, end_blk =  
> 1) then
> len_blks = 2 which is too much.

I think that len_blks = 2 is the correct value, because the requested
region extends into 2 blocks (namely 0 and 1). If both blocks are in two
separate extents, then ext4_ext_walk_space should report 2 extents. (If
it's the same extent, only 1 will be reported anyways)

> I think the right calculation here is:
> 
>                    end_blk = (start + len + inode->i_sb->s_blocksize - 1) >>
>                              inode->i_sb->s_blocksize_bits;
>                    len_blks = end_blk - start_blk;
> 

This is exactly the same (provided that len > 0). You can convince
yourself easily that ((blocksize + x) >> blocksize_bits == x >>
blocksize_bits + 1) for any positive x, because the lower bits of
blocksize are all 0. (Your calculation would handle the case len == 0
right, if that was allowed.)

Regards
Leonard
