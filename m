From: Mingming <cmm@us.ibm.com>
Subject: Re: [RFC,PATCH 2/2] Direct IO for holes and fallocate
Date: Tue, 18 Aug 2009 15:49:10 -0700
Message-ID: <1250635750.9822.31.camel@mingming-laptop>
References: <1249916431.4337.33.camel@mingming-laptop>
	 <20090818001831.GB1215@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, Curt Wohlgemuth <curtw@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:60265 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZHRWtR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Aug 2009 18:49:17 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7IMeCL7020259
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 16:40:12 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7IMnEpb261828
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 16:49:14 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7IMnDD1021355
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 16:49:14 -0600
In-Reply-To: <20090818001831.GB1215@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-08-17 at 20:18 -0400, Theodore Tso wrote:
> Here's my suggest rewrite of the patch description:
> 
> ext4: Direct IO for holes and fallocate: unwritten extents spt for DIO
> 
> From: Mingming <cmm@us.ibm.com>
> 
> When writing into an unitialized extent via direct I/O, and the direct
> I/O doesn't exactly cover the unitialized extent, split the extent
> into uninitialized and initialized extents before submitting the I/O.
                         ~~~~~~~~~~~~
would it better to replace this as to-be-initialized extents? Before
submmit the I/O, the extents are splitted but all remains uninitialized.
The written part is converted to initialized at the time I/O is
complete.

> The reason for doing this is to avoid needing to deal with an ENOSPC
> error in the end_io callback that gets used for direct I/O.
> 
> Singed-Off-By: Mingming Cao <cmm@us.ibm.com> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> ------------------
> 
> 
> As mentioned in my comments for the previous patch,
> ext4_convert_unwritten_extents() needs to be defined in the previous
> patch.  This may requiring dragging in substantial portions of this
> patch.
> 
> The other observation is there seems to be quite a bit of overlap
> between ext4_split_unwritten_extents() and
> ext4_ext_convert_to_initialized().  Is there some way we can do some
> code factorization?
> 

I thought about factor the code before... that would require passing a
flag and avoid the convertion(as for DIO case we only do split) and zero
out( DIO does less agreesive zero out than buffered IO). It makes code
actually hard to read. I will give it a try to see if we could reuse the
code while still make the code easy to understand.

Thanks,
Mingming
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


