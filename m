From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V2] ext4: serialize unaligned asynchronous DIO
Date: Fri, 21 Jan 2011 10:00:01 -0600
Message-ID: <4D39AD81.4010407@redhat.com>
References: <4D2F7B52.1040209@redhat.com> <20110114041514.GI31800@thunk.org> <4D3087CE.2060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab1AUQAE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 11:00:04 -0500
In-Reply-To: <4D3087CE.2060200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/14/11 11:28 AM, Eric Sandeen wrote:
> 
> 
> ext4 has a data corruption case when doing non-block-aligned
> asynchronous direct IO into a sparse file, as demonstrated
> by xfstest 240.
> 
> The root cause is that while ext4 preallocates space in the
> hole, mappings of that space still look "new" and 
> dio_zero_block() will zero out the unwritten portions.  When
> more than one AIO thread is going, they both find this "new"
> block and race to zero out their portion; this is uncoordinated
> and causes data corruption.
> 
> Dave Chinner fixed this for xfs by simply serializing all
> unaligned asynchronous direct IO.  I've done the same here.
> This is a very big hammer, and I'm not very pleased with
> stuffing this into ext4_file_write().  But since ext4 is
> DIO_LOCKING, we need to serialize it at this high level.
> 
> I tried to move this into ext4_ext_direct_IO, but by then
> we have the i_mutex already, and we will wait on the
> work queue to do conversions - which must also take the
> i_mutex.  So that won't work.
> 
> This was originally exposed by qemu-kvm installing to
> a raw disk image with a normal sector-63 alignment.  I've
> tested a backport of this patch with qemu, and it does
> avoid the corruption.  It is also quite a lot slower
> (14 min for package installs, vs. 8 min for well-aligned)
> but I'll take slow correctness over fast corruption any day.
> 
> Mingming suggested that perhaps we can track outstanding
> conversions, and wait on that instead so that non-sparse
> files won't be affected, but I've had trouble making that
> work so far, and would like to get the corruption hole
> plugged ASAP.  Perhaps adding a prink_once() warning of
> the perf degradation on this path would be useful?
> 

I've sent a patch to do the above, as V3, twice now, but the list
is eating it.  Ted, you were cc'd so hopefully you got it?

-Eric
