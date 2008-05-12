From: "Eric A" <erpo41@gmail.com>
Subject: Re: Fwd: barriers off by default?
Date: Mon, 12 May 2008 13:11:51 -0600
Message-ID: <72c5d9a0805121211l50e1b136xf33e0b3b7fda103c@mail.gmail.com>
References: <482868A5.1000102@redhat.com>
	 <72c5d9a0805121030y709de9cehc01df8aeb5b1b8d3@mail.gmail.com>
	 <482883FD.8060001@redhat.com>
	 <72c5d9a0805121150j58482bc6qd57a87089ce4414e@mail.gmail.com>
	 <72c5d9a0805121151m2d838f3cxe61368b928dc5db2@mail.gmail.com>
	 <482893C2.7000709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:58808 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844AbYELTLz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 15:11:55 -0400
Received: by ti-out-0910.google.com with SMTP id b6so837897tic.23
        for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 12:11:53 -0700 (PDT)
In-Reply-To: <482893C2.7000709@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2008 at 1:00 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> Eric A wrote:
>  >  Documentation/block/barrier.txt
>  >
>  >  There's a section that starts:
>  >
>  >  "* Error handling.  Currently, block layer will report error to upper
>  >  layer if any of requests in an ordered sequence fails.  Unfortunately,
>  >  this doesn't seem to be enough. "
>
>
>
> And ends:
>
>  "As the probability of this happening is very low and the drive should
>  be faulty, implementing the fix is probably an overkill.  But, still,
>  it's there."
>
>  I'm not sure it's an argument for disabling barriers in general.   :)

I agree; it's just something that's been bugging me since I started
searching for a solution for zfs-fuse. Maybe performance is the
reason? Flushing the write cache is kind of slow.

Cheers,
Eric
