From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix overhead calculation in bigalloc filesystem
 (Re: ... )
Date: Thu, 21 Feb 2013 15:56:51 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1302211553060.14141@localhost>
References: <1361433665-16880-1-git-send-email-lczerner@redhat.com> <20130221121545.GA30821@gmail.com> <alpine.LFD.2.00.1302211335390.19354@localhost> <alpine.LFD.2.00.1302211346240.19354@localhost> <alpine.LFD.2.00.1302211351090.19354@localhost>
 <20130221134943.GA3818@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab3BUO47 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2013 09:56:59 -0500
In-Reply-To: <20130221134943.GA3818@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 21 Feb 2013, Zheng Liu wrote:

..snip..

> > > > >  	/*
> > > > >  	 * All of the blocks before first_data_block are overhead
> > > > >  	 */
> > > > > -	overhead = EXT4_B2C(sbi, le32_to_cpu(es->s_first_data_block));
> > > > > +	overhead = EXT4_NUM_B2C(sbi, le32_to_cpu(es->s_first_data_block));
> > > 
> > > ...except this. I do not think this is right because we do not skip
> > > the first cluster right ? We're still using it, but we can never use
> > > the block before es->s_first_data_block. Please correct me if I am
> > > wrong.
> 
> Yes, I think you are right.
> 
> > 
> > moreover we do not allow bigalloc file system with block size < 4k.
> 
> No, we allow user to use bigalloc with block size < 4k, such as:
> 
>   mkfs.ext4 -b 1024 -C 4096 -O bigalloc ${dev}
> 
> This command formats a bigalloc filesystem with blocksize = 1k and
> clustersize = 4k, at least in e2fsprogs 1.42.7 it works well.
> 

Ok, i was pretty sure that we do not allow that, it's good to know.
Also, does it make any sense ? I do not think so, and I would really
consider the fact that we allow that as a bug. We should not allow
that otherwise it unnecessarily extending the test matrix.

What people think about restricting bigalloc _only_ for 4k block
size file systems ?

Thanks!
-Lukas
