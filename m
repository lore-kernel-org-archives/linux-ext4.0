From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [RFC][PATCH 0/3] ext4 online defrag (ver 0.2)
Date: Tue, 16 Jan 2007 12:41:52 -0800
Message-ID: <20070116204152.GI27360@ca-server1.us.oracle.com>
References: <20070116210346sho@rifu.tnes.nec.co.jp> <20070116192134.GB5236@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet02.oracle.com ([148.87.113.119]:21800 "EHLO
	rgminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbXAPUsR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2007 15:48:17 -0500
To: sho@tnes.nec.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20070116192134.GB5236@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 16, 2007 at 12:21:34PM -0700, Andreas Dilger wrote:
> On Jan 16, 2007  21:03 +0900, sho@tnes.nec.co.jp wrote:
> > 2. The new entry "goal" is added on ext4_ext_defrag_data structure
> >    which is passed to existing ioctl(EXT4_IOC_DEFRAG)
> >    as the argument.  The kernel starts searching the free blocks
> >    from "goal".  The command passes the physical block number
> >    gotten in the above step(1) to the ioctl.
> > 
> > struct ext4_ext_defrag_data {
> >         loff_t start_offset; /* start offset to defrag in byte */
> >         loff_t defrag_size;  /* size of defrag in bytes */
> > 	ext4_fsblk_t goal;   /* block offset for allocation */
> > };
> 
> Two things of note:
> - presumably the start_offset and defrag_size should be multiples of the
>   filesystem blocksize?  If they are not, is it an error or are they
>   adjusted to cover whole blocks?

	In fact, why aren't the units in blocks?  THe filesystem isn't
really going to deal with anything smaller, is it?

Joel

-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
