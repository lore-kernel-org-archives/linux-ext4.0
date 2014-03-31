From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] ext4: Fix flag handling in
 ext4_split_convert_extents()
Date: Mon, 31 Mar 2014 17:19:35 +0300
Message-ID: <20140331141935.GC18506@mwanda>
References: <1396257094-10386-1-git-send-email-lczerner@redhat.com>
 <874n2emp7s.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37487 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaCaOTp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Mar 2014 10:19:45 -0400
Content-Disposition: inline
In-Reply-To: <874n2emp7s.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 31, 2014 at 06:12:39PM +0400, Dmitry Monakhov wrote:
> On Mon, 31 Mar 2014 11:11:33 +0200, Lukas Czerner <lczerner@redhat.com> wrote:
> > In commit 1f0e51771281 "ext4: Introduce FALLOC_FL_ZERO_RANGE flag
> > for fallocate" we've introduced wrong flag handling. Fix it.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/extents.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 243a02e..491208c 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -3644,13 +3644,13 @@ static int ext4_split_convert_extents(handle_t *handle,
> >  	ee_len = ext4_ext_get_actual_len(ex);
> >  
> >  	/* Convert to unwritten */
> > -	if (flags | EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
> > +	if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
> :).  But how did you found this? 
> I think that this type of bugs should be caught by some semantics
> analyzer? I've done simple test and sparse(1) owerlooked this,
> Also I cant find specific rule for Coccinelle ( if (var | CONST)).

This one was found with a Smatch warning:

fs/ext4/extents.c:3647 ext4_split_convert_extents() warn: suspicious bitop condition

> 
> >  		split_flag |= EXT4_EXT_DATA_VALID1;
> >  	/* Convert to initialized */
> > -	} else if (flags | EXT4_GET_BLOCKS_CONVERT) {
> > +	} else if (flags & EXT4_GET_BLOCKS_CONVERT) {
> >  		split_flag |= ee_block + ee_len <= eof_block ?
> >  			      EXT4_EXT_MAY_ZEROOUT : 0;
> > -		split_flag |= (EXT4_EXT_MARK_UNINIT2 & EXT4_EXT_DATA_VALID2);
> > +		split_flag |= (EXT4_EXT_MARK_UNINIT2 | EXT4_EXT_DATA_VALID2);

I would like to push the Smatch warning for this one as well, but there
are too many places where these kinds of AND operations are valid.

regards,
dan carpenter

