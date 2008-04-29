From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: jbd2 patches in stable queue
Date: Tue, 29 Apr 2008 01:52:53 +0100
Message-ID: <e9e943910804281752r5a0b9228u382934eb0f8514f0@mail.gmail.com>
References: <48162E6B.8010607@redhat.com>
	 <1209414300.13477.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Eric Sandeen" <sandeen@redhat.com>,
	"ext4 development" <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:62536 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbYD2Awy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2008 20:52:54 -0400
Received: by wf-out-1314.google.com with SMTP id 28so4263263wff.4
        for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2008 17:52:53 -0700 (PDT)
In-Reply-To: <1209414300.13477.10.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

2008/4/28 Mingming Cao <cmm@us.ibm.com>:
> On Mon, 2008-04-28 at 15:07 -0500, Eric Sandeen wrote:
>  > Ted et al:
>  >
>  > these 3 patches in the stable queue:
>  >
>  > patches/jbd2-tidy-up-revoke-cache-initialization-and-destruction.patch
>  > patches/jbd2-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
>  > patches/jbd2-replace-potentially-false-assertion-with-if-block.patch
>  >
>  > don't seem to have their jbd counterparts merged anywhere, -mm or Linus'
>  > tree.
>  >
>  As far as I remember, they(at least the first 2) used to be in mm tree
>  then later when the author submit updated patches, Andrew got confused
>  with the relationship with previous patches so he took them all out.

That's right, although there were also some merge conflicts involved.
He asked me to resubmit them against -mm, but I've not had time to do
it yet, sorry. I'm in my last couple of weeks at my current job and
I'm very busy getting everything finished off there. After that  I
hope to be focusing full-time on finishing off the ext3/4
no-replay-on-R/O-mount work. Assuming I can figure out a way to make
it work cleanly, that is :)

Anyway, apologies again for not following up on those patches. I'll
try and get the jbd versions done against -mm this weekend, if no-one
beats me to it.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
