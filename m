From: NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [patch]ext4: add block plug for .writepages
Date: Tue, 11 Oct 2011 09:07:56 +0900
Message-ID: <CAKYAXd_Akk_9yNM-ZN=8hYM=0JEKSzzqXLjbQY9auPK0Qe6NoQ@mail.gmail.com>
References: <1317004226.29510.172.camel@sli10-conroe>
	<20110926073025.GB21079@infradead.org>
	<1317022727.29510.175.camel@sli10-conroe>
	<20110926094554.GA30827@infradead.org>
	<1317179380.22361.8.camel@sli10-conroe>
	<20111010165116.GX7948@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Shaohua Li <shaohua.li@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <l
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47421 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab1JKAH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Oct 2011 20:07:57 -0400
In-Reply-To: <20111010165116.GX7948@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/10/11 Ted Ts'o <tytso@mit.edu>:
> On Wed, Sep 28, 2011 at 11:09:40AM +0800, Shaohua Li wrote:
>> I searched a little bit, looks only ext4 need it. here is the patch.
>>
>>
>> Add block plug for ext4 .writepages. Though ext4 .writepages
>> already handles request merge very well, block plug is still
>> helpful to reduce block lock contention.
>>
>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
You found good point.
If there are other filesystem that didn't use generic_writepages,
these are needed as this patch.

Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
>
> Thanks, applied.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-=
 Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
