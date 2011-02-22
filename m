From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: allow inode_readahead_blks=0 (linux-2.6.37)
Date: Mon, 21 Feb 2011 21:32:11 -0500
Message-ID: <20110222023211.GF2924@thunk.org>
References: <20110208063925.GA13619@lw.yar.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	linux-kernel@vger.kernel.org
To: "Alexander V. Lukyanov" <lav@netis.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110208063925.GA13619@lw.yar.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 08, 2011 at 09:39:25AM +0300, Alexander V. Lukyanov wrote:
> Hello!
> 
> I cannot disable inode-read-ahead feature of ext4 (on 2.6.37):
> 
> # echo 0 > /sys/fs/ext4/sda2/inode_readahead_blks 
> bash: echo: write error: Invalid argument
> 
> On a server with lots of small files and random access this read-ahead makes
> performance worse, and I'd like to disable it. I work around this problem
> by using value of 1, but it still reads an extra block.

So I'm curious --- have you actually benchmarked a performance
decrease?  What sort of hardware are you using?

The readahead should be changing a 4k read to a 8k read with a value
of 1, which shouldn't take a much of a difference to a HDD.

I can apply this patch, but is it really making a difference for you?

      	    	 	       	  	 	- Ted
