From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][Patch 1/1] Persistent preallocation in ext4
Date: Tue, 12 Dec 2006 11:53:02 +0530
Message-ID: <20061212062302.GA8280@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061206055822.GA6182@amitarora.in.ibm.com> <1165886895.3939.18.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38534 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbWLLGXE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Dec 2006 01:23:04 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBC6N3hn012539
	for <linux-ext4@vger.kernel.org>; Tue, 12 Dec 2006 01:23:03 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBC6N3Ow134672
	for <linux-ext4@vger.kernel.org>; Tue, 12 Dec 2006 01:23:03 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBC6N3xS023585
	for <linux-ext4@vger.kernel.org>; Tue, 12 Dec 2006 01:23:03 -0500
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <1165886895.3939.18.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Mingming,

On Mon, Dec 11, 2006 at 05:28:15PM -0800, Mingming Cao wrote:
> On Wed, 2006-12-06 at 11:28 +0530, Amit K. Arora wrote:
> 
> > @@ -1142,13 +1155,22 @@
> >  	/* try to insert block into found extent and return */
> >  	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
> >  		ext_debug("append %d block to %d:%d (from %llu)\n",
> > -				le16_to_cpu(newext->ee_len),
> > +				ext4_ext_get_actual_len(newext),
> >  				le32_to_cpu(ex->ee_block),
> > -				le16_to_cpu(ex->ee_len), ext_pblock(ex));
> > +				ext4_ext_get_actual_len(ex), ext_pblock(ex));
> >  		if ((err = ext4_ext_get_access(handle, inode, path + depth)))
> >  			return err;
> > -		ex->ee_len = cpu_to_le16(le16_to_cpu(ex->ee_len)
> > -					 + le16_to_cpu(newext->ee_len));
> > +
> > +		/* ext4_can_extents_be_merged should have checked that either
> > +		 * both extents are uninitialized, or both aren't. Thus we
> > +		 * need to check any of them here.
> > +		 */
> > +		if (ext4_ext_is_uninitialized(ex))
> > +			uninitialized = 1;
> > +		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
> > +					 + ext4_ext_get_actual_len(newext));

Above line will "remove" the uninitialized bit from "ex", if it was set.
We call ext4_ext_get_actual_len() to get the "actual" lengths of the two
extents, which removes this MSB in ee_len (MSB in ee_len is used to mark
an extent uninitialized). Now, we do this because if lengths of two
uninitialized extents will be added as it is (i.e. without masking out
the MSB in the length), it will result in removing the MSB in ee_len.
For example, 0x8002 + 0x8003 => 0x10005 => 0x5 (since ee_len is 16 bit).

That is why just before this line, we save the "state" of this extent,
whether it was uninitialized or not. And, we restore this "state" below.

> > +		if(uninitialized)
> > +			ext4_mark_uninitialized_ext(ex);
> >  		eh = path[depth].p_hdr;
> >  		nearex = ex;
> >  		goto merge;
> 
> Hmm, I missed the point to re-mark an uninitialized extent here. If ex
> is an uninitialized extent, the mark(the first bit the ee_len) shall
> still there after the update, isn't?  We already make sure that two
> large uninitialized extent can't get merged if the resulting length will
> take the first bit, which used as the mark of uninitialized extent.

Please get back if you do not agree with the explanation above and if I
am missing something here. Thanks!

Regards,
Amit Arora
