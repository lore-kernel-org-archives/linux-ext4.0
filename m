From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][Patch 1/2] Persistent preallocation in ext4
Date: Tue, 2 Jan 2007 16:34:09 +0530
Message-ID: <20070102110409.GB5932@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061206055822.GA6182@amitarora.in.ibm.com> <20061215123528.GA24572@amitarora.in.ibm.com> <1167262245.3792.20.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, suzuki@in.ibm.com,
	alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51099 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbXABLER (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jan 2007 06:04:17 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l02B4GR4008536
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 06:04:16 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l02B4FHF131540
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 06:04:16 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l02B4EVX026232
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 06:04:15 -0500
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <1167262245.3792.20.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Mingming,

On Wed, Dec 27, 2006 at 03:30:44PM -0800, Mingming Cao wrote:
> looks good to me, a few comments :)
Thanks for your comments!

> .....
> > +	  		ret = ext4_ext_get_blocks(handle, inode, block,
> > +					max_blocks, &map_bh,
> > +					EXT4_CREATE_UNINITIALIZED_EXT, 0);
> > +			if(ret > 0 && test_bit(BH_New, &map_bh.b_state))
> > +				nblocks = nblocks + ret;
> > +		}
> 
> 
> ext4_ext_get_blocks() returns 0 when it is mapping (non allocating) a
> hole. In our case, we are doing allocating, so here it is not possible
> to returns a 0 from ext4_ext_get_blocks(). I think we should quit the
> loop and BUGON if ret == 0 here.

Okay. I will add "BUG_ON(!ret);" just after get_blocks, above.

> 
> > +		if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb,
> > +						&retries))
> > +			goto retry;
> > +
> > +		if(nblocks) {
> > +			mutex_lock(&inode->i_mutex);
> > +			inode->i_size = inode->i_size + (nblocks >> blkbits);
> > +			EXT4_I(inode)->i_disksize = inode->i_size;
> > +			mutex_unlock(&inode->i_mutex);
> > +		}
> 
> Hmm... We should not need to worry about the inode->i_size if we are
> preallocating blocks for holes.

You are right. Will take care of this.
 
> And, Looking at other places calling ext4_*_get_blocks() in the kernel,
> it seems not all of them protected by i_mutex lock. I think it probably
> okay to not holding i_mutex during calling ext4_ext4_get_blocks().

We are not holding i_mutex lock during ext4_ext_get_blocks() call.
Above, this lock is being held inorder to avoid race while updating the
filesize in inode (reference your comment in a previous mail "I think we
should update i_size and i_disksize after preallocation. Oh,
to protect parallel updating i_size, we have to take i_mutex down.").
Perhaps, truncate_mutex lock should be used here, and not i_mutex.

> 
> > +
> > +		ext4_mark_inode_dirty(handle, inode);
> > +		ret2 = ext4_journal_stop(handle);
> > +		if(ret > 0)
> > +			ret = ret2;
> > +
> > +		return ret > 0 ? nblocks : ret;
> > +	}
> > +
> 
> Since the API takes the number of bytes to preallocate, at return time,
> shall we convert the blocks to bytes to the user?
> 
> Here it returns the number of allocated blocks to the user.   Do we need
> to worry about the case when dealing with a range with partial hole and
> partial blocks already allocated? In that case nblocks(the new
> preallocated blocks) will less than the maxblocks (the number of blocks
> asked by application).  I am wondering what does other filesystem like
> xfs do? Maybe we should do the same thing.

I think xfs just returns 0 on success, and errno on an error. Do we
want to keep the same behavior here ? Or, should we return the number of
bytes preallocated ?

Thanks!

--
Regards,
Amit Arora
