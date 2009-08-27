From: Jan Kara <jack@suse.cz>
Subject: Re: Buffer state bits
Date: Thu, 27 Aug 2009 16:32:15 +0200
Message-ID: <20090827143215.GD14240@duck.novell.com>
References: <20090826200021.GA5716@duck.novell.com> <20090827123318.GA19422@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49131 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZH0OcP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Aug 2009 10:32:15 -0400
Content-Disposition: inline
In-Reply-To: <20090827123318.GA19422@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 27-08-09 18:03:18, Aneesh Kumar K.V wrote:
> > 
> > BH_Mapped
> > - Buffer has a physical block backing it stored in b_bdev + b_blocknr. This bit
> >   is set by filesystem's get_block() function (or by VFS itself for block device
> >   mappings).
> > 
> >   XXX: Some filesystems set BH_Mapped even for buffers that do no really
> >   have the backing block (like buffers for delayed allocation). I think
> >   we should get rid of it...
> > 
> 
> Also we don't want get_block to be called multiple times for the same file offset.
> __block_prepare_write does get_block looking at the BH_Mapped flag. ie one of reason
> delay and unwritten buffer_heads are also marked mapped.
  Unwritten buffers should be mapped as they really have the backing block.
So that's fine.
  Delayed buffers should not be mapped. We could change the check in
__block_prepare_write to "!buffer_mapped(bh) && !buffer_delay(bh)". But I'd
rather avoid it because what I'd like to do in ext3 is to delay-allocate
mmapped blocks and allocate normally blocks written via write(2). So I want
ext3_get_block() to be called in block_prepare_write() even for delay
buffers.
   If ext4 doesn't want to do anything for delay buffers in get_block() called
from block_prepare_write(), it can just return from the beginning of
ext4_get_block() when it finds the buffer is delay...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
