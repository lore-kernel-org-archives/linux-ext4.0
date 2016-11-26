From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix mmp use after free during unmount
Date: Sat, 26 Nov 2016 14:31:07 -0500
Message-ID: <20161126193107.yy4fmkiliqeyz7uy@thunk.org>
References: <0b8909ed-ae65-1a89-263c-12aff513377a@redhat.com>
 <B4E24389-6BE1-4896-B426-EB60172133E3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        shuwang@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57592 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750833AbcKZTbR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 26 Nov 2016 14:31:17 -0500
Content-Disposition: inline
In-Reply-To: <B4E24389-6BE1-4896-B426-EB60172133E3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 20, 2016 at 02:26:38PM -0600, Andreas Dilger wrote:
> On Oct 20, 2016, at 12:19 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > 
> > In ext4_put_super, we call brelse on the buffer head containing
> > the ext4 superblock, but then try to use it when we stop the
> > mmp thread, because when the thread shuts down it does:
> > 
> > write_mmp_block
> >  ext4_mmp_csum_set
> >    ext4_has_metadata_csum
> >      WARN_ON_ONCE(ext4_has_feature_metadata_csum(sb)...)
> > 
> > which reaches into sb->s_fs_info->s_es->s_feature_ro_compat,
> > which lives in the superblock buffer s_sbh which we just released.
> > 
> > Fix this by moving the brelse down to a point where we are no
> > longer using it.
> > 
> > Reported-by: Wang Shu <shuwang@redhat.com>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
