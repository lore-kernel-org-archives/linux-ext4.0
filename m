From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC, PATCH 6/6] ext3: do not write to the disk when mounting
	a dirty read-only filesystem
Date: Wed, 12 Mar 2008 11:53:51 +0100
Message-ID: <20080312105351.GC3090@duck.suse.cz>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com> <f4577a0cc4262de0fbff02cae3858d2e2edfaaea.1204685366.git.duaneg@dghda.com> <20080306071734.GN3616@webber.adilger.int> <20080311151122.GD6544@atrey.karlin.mff.cuni.cz> <20080312024246.GB21711@dastardly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47518 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751247AbYCLKxw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2008 06:53:52 -0400
Content-Disposition: inline
In-Reply-To: <20080312024246.GB21711@dastardly.plus.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 12-03-08 02:42:46, Duane Griffin wrote:
> On Tue, Mar 11, 2008 at 04:11:23PM +0100, Jan Kara wrote:
> >   Actually, this is nastier than it looks - currently fs, asks
> > ext3_sb_getblk() for block 'a' and it gets buffer head with b_blocknr == 'b'
> > instead.
> 
> Note that it will be a different device as well, in the case of an
> external journal.
> 
> > So when remounting you'd have to rewrite these buffers with
> > original block numbers which is not really possible. So I think
> > remapping will have to be solved differently, like providing buffer
> > head with correct b_blocknr but taking care when reading data to it and
> > reading them from elsewhere. Actually, this has to be done anyway
> > because JBD escapes data in the journal and you have to do unescaping
> > when reading data...
> 
> Hmm, I'll think about this and try to get something working. As a quick
> proof-of-concept hack, getting both buffers then overwriting the fs
> block's data with the unescaped journal data should do the trick, right?
  Yes, it should, but you should take care for users that do things like:

  getblk(a)
  ll_rw_block(READ, a)

  or even

  getblk(a)
  submit_bh(a)

  I'm not sure if there are any in ext3/ext4 but it definitely needs
checking.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
