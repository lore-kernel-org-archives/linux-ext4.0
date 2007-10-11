From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext2: Avoid rec_len overflow with 64KB block size
Date: Thu, 11 Oct 2007 12:30:03 +0200
Message-ID: <20071011103003.GB7125@duck.suse.cz>
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com> <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain> <1191285346.11737.58.camel@localhost.localdomain> <20071004131207.65406a7b.akpm@linux-foundation.org> <20071004224044.GH5628@schatzie.adilger.int> <20071004161121.f51972e8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sho@tnes.nec.co.jp, clameter@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34121 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753422AbXJKKHU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 06:07:20 -0400
Content-Disposition: inline
In-Reply-To: <20071004161121.f51972e8.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 04-10-07 16:11:21, Andrew Morton wrote:
> On Thu, 4 Oct 2007 16:40:44 -0600
> Andreas Dilger <adilger@clusterfs.com> wrote:
> 
> > On Oct 04, 2007  13:12 -0700, Andrew Morton wrote:
> > > On Mon, 01 Oct 2007 17:35:46 -0700
> > > > ext2: Avoid rec_len overflow with 64KB block size
> > > > 
> > > > into 16 bits we have for entry lenght. So we store 0xffff instead and
> > > > convert value when read from / written to disk.
> > > 
> > > This patch clashes in non-trivial ways with
> > > ext2-convert-to-new-aops-fix.patch and perhaps other things which are
> > > already queued for 2.6.24 inclusion, so I'll need to ask for an updated
> > > patch, please.
> > 
> > If the rel_len overflow patch isn't going to make it, then we also need
> > to revert the EXT*_MAX_BLOCK_SIZE change to 65536.  It would be possible
> > to allow this to be up to 32768 w/o the rec_len overflow fix however.
> > 
> 
> Ok, thanks, I dropped ext3-support-large-blocksize-up-to-pagesize.patch and
> ext2-support-large-blocksize-up-to-pagesize.patch.
  Sorry, for the delayed answer but I had some urgent bugs to fix...
Why did you drom ext3-support-large-blocksize-up-to-pagesize.patch? As far
as I understand your previous email (and also as I've checked against
2.6.23-rc8-mm2), the patch fixing rec_len overflow clashes only for ext2...
  I'll send you an updated patch for ext2 in a moment.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
