From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 7/7] ext4: don't update checksum of new initialized
 bitmaps
Date: Thu, 22 Mar 2018 11:29:52 -0400
Message-ID: <20180322152952.GF2852@thunk.org>
References: <20180220023038.19883-1-tytso@mit.edu>
 <20180220023038.19883-8-tytso@mit.edu>
 <20180307090607.wfkplsuvigaoie5o@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180307090607.wfkplsuvigaoie5o@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 07, 2018 at 10:06:07AM +0100, Jan Kara wrote:
> 
> Probably you should remove the bad checksum handling in
> ext4_init_block_bitmap() the same way as you did in
> ext4_init_inode_bitmap()? Otherwise the patch looks good.

There isn't an ext4_init_inode_bitmap() --- the functionality is
inlined ext4_read_inode_bitmap(), and it's already doing it that way
(it doesn't set the checksum; it just sets the verified bit).

    	    	    	      	      - Ted
    
