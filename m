From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ext4: ext4_discard_partial_page_buffers_no_lock()
 wrong parameters
Date: Mon, 12 Dec 2011 13:07:47 -0700
Message-ID: <4EE65F13.3030800@linux.vnet.ibm.com>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com> <1323656828-24465-3-git-send-email-aarcange@redhat.com> <CAGBYx2YTiHq4mkY5uh3ZawOAz1hbdzfgV2faBDEYZz-k9bySAA@mail.gmail.com> <20111212165517.GE16411@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Andrea Arcangeli <aarcange@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33137 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab1LLUIM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Dec 2011 15:08:12 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Mon, 12 Dec 2011 15:08:11 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBCK7p2B216890
	for <linux-ext4@vger.kernel.org>; Mon, 12 Dec 2011 15:07:52 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBCK7nXY012820
	for <linux-ext4@vger.kernel.org>; Mon, 12 Dec 2011 18:07:50 -0200
In-Reply-To: <20111212165517.GE16411@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/12/2011 09:55 AM, Andrea Arcangeli wrote:
> On Mon, Dec 12, 2011 at 11:17:54AM +0800, Yongqiang Yang wrote:
>> Hi Andrea,
>>
>> The code you are testing are removed in recent patches,  the patches
>> have not been merged.
>
> I checked out the git ext4 tree and the two patches applies clean to
> it. So I'm unsure why you say it was removed. origin/dev origin/master
> are equal too.
>
>>
>> Please try following patches:
>> [PATCH 1/2] ext4: let mpage_submit_io works well when blocksize<  pagesize
>> [PATCH 2/2] ext4: let ext4_discard_partial_buffers handle pages
>> without buffers correctly
>>
>> and
>>
>> [PATCH 1/2] ext4: remove a wrong BUG_ON in ext4_ext_convert_to_initialized
>> [PATCH 2/2] ext4: let ext4_bio_write_page handle EOF correctly
>
> Is there a git tree with these patches? I'm not subscribed to the list.
>
> Thanks,
> Andrea

Hi Andrea,

I think what Yongqiang means is that the code you are modifying is being 
removed in the patches listed above and replaced with a different 
solution.  The patches have not yet been merged so you will not see them 
in a git tree yet, so you will need to apply them yourself.  If you are 
not subscribed to the list, you can still find the patches here:

http://www.spinics.net/lists/linux-ext4/msg29109.html
http://www.spinics.net/lists/linux-ext4/msg29110.html

http://www.spinics.net/lists/linux-ext4/msg29375.html
http://www.spinics.net/lists/linux-ext4/msg29376.html

We want to make sure the solution works for everyone, so please apply 
these patches and let us know if it corrects the issues you are seeing. 
  Thx!

Allison Henderson

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

