From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] ext4: ext4_discard_partial_page_buffers_no_lock()
 wrong parameters
Date: Tue, 13 Dec 2011 09:16:24 +0800
Message-ID: <CAGBYx2Znz3U4zE9gquabkFrPG6ZfLXRKc6WMc_SbUJRxUf9zfA@mail.gmail.com>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
	<1323656828-24465-3-git-send-email-aarcange@redhat.com>
	<CAGBYx2YTiHq4mkY5uh3ZawOAz1hbdzfgV2faBDEYZz-k9bySAA@mail.gmail.com>
	<20111212165517.GE16411@redhat.com>
	<4EE65F13.3030800@linux.vnet.ibm.com>
	<20111213004047.GH16411@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>,
	Andy Whitcroft <apw@canonical.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45101 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab1LMBQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Dec 2011 20:16:25 -0500
Received: by ggdk6 with SMTP id k6so1830299ggd.19
        for <linux-ext4@vger.kernel.org>; Mon, 12 Dec 2011 17:16:24 -0800 (PST)
In-Reply-To: <20111213004047.GH16411@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 13, 2011 at 8:40 AM, Andrea Arcangeli <aarcange@redhat.com>=
 wrote:
> Hi Allison,
>
> On Mon, Dec 12, 2011 at 01:07:47PM -0700, Allison Henderson wrote:
>> Hi Andrea,
>>
>> I think what Yongqiang means is that the code you are modifying is b=
eing
>> removed in the patches listed above and replaced with a different
>> solution. =A0The patches have not yet been merged so you will not se=
e them
>> in a git tree yet, so you will need to apply them yourself. =A0If yo=
u are
>> not subscribed to the list, you can still find the patches here:
>>
>> http://www.spinics.net/lists/linux-ext4/msg29109.html
>> http://www.spinics.net/lists/linux-ext4/msg29110.html
>>
>> http://www.spinics.net/lists/linux-ext4/msg29375.html
>> http://www.spinics.net/lists/linux-ext4/msg29376.html
>
> Thanks for the links. Applied all 4.
>
>> We want to make sure the solution works for everyone, so please appl=
y
>> these patches and let us know if it corrects the issues you are seei=
ng.
>> =A0 Thx!
>
> With all 4 patches applied, my 1/2 patch is still needed to avoid the
> hang and writes hangs all the time (but now they don't return -EINVAL
> anymore).
>
> My patch 2/2 is not needed with the above 4 patches applied so that
> can be discared if you apply the above 4 patches (but I suggest you
> check my patch 2/2 too because if it happens to be correct it could
> mean there's the potential of 1 byte data corruption in current
> upstream kernels in some circumstances, in addition to the -EINVAL
> failure in write()).
page_len is removed in the 2nd patch, so there is no problem related
to it any more.

Hi Andy and Hugh,

Andrea found the reason of EINVAL,  and the 2nd patch we have tested
can fix it.  Many thanks to Andrea.


Yongqiang.
>
> Let me know if you need me to test me anything else in relation to th=
e
> copied=3D0 case.
>
> Thanks,
> Andrea



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
