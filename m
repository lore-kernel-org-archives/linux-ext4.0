From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ext2: Avoid rec_len overflow with 64KB block size
Date: Thu, 4 Oct 2007 16:11:21 -0700
Message-ID: <20071004161121.f51972e8.akpm@linux-foundation.org>
References: <20070828190551.415127746@sgi.com>
	<20070828190735.292638294@sgi.com>
	<1188432669.3799.35.camel@localhost.localdomain>
	<1188434857.3799.76.camel@localhost.localdomain>
	<1191285346.11737.58.camel@localhost.localdomain>
	<20071004131207.65406a7b.akpm@linux-foundation.org>
	<20071004224044.GH5628@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, sho@tnes.nec.co.jp, jack@suse.cz,
	clameter@sgi.com
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537AbXJDXMB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Oct 2007 19:12:01 -0400
In-Reply-To: <20071004224044.GH5628@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 4 Oct 2007 16:40:44 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> On Oct 04, 2007  13:12 -0700, Andrew Morton wrote:
> > On Mon, 01 Oct 2007 17:35:46 -0700
> > > ext2: Avoid rec_len overflow with 64KB block size
> > > 
> > > into 16 bits we have for entry lenght. So we store 0xffff instead and
> > > convert value when read from / written to disk.
> > 
> > This patch clashes in non-trivial ways with
> > ext2-convert-to-new-aops-fix.patch and perhaps other things which are
> > already queued for 2.6.24 inclusion, so I'll need to ask for an updated
> > patch, please.
> 
> If the rel_len overflow patch isn't going to make it, then we also need
> to revert the EXT*_MAX_BLOCK_SIZE change to 65536.  It would be possible
> to allow this to be up to 32768 w/o the rec_len overflow fix however.
> 

Ok, thanks, I dropped ext3-support-large-blocksize-up-to-pagesize.patch and
ext2-support-large-blocksize-up-to-pagesize.patch.
