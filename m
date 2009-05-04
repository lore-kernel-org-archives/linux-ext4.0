From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Question on block group allocation
Date: Mon, 4 May 2009 08:52:05 -0700
Message-ID: <6601abe90905040852w3846b3bened28369dd4ce6f49@mail.gmail.com>
References: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com>
	 <6601abe90904231502y393155dbrf8913b728c704320@mail.gmail.com>
	 <20090427021411.GA9059@mit.edu>
	 <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com>
	 <20090427224052.GC22104@mit.edu> <20090429191646.GF14264@mit.edu>
	 <6601abe90904291138r6e24c04dj4b2efcdba22bf84@mail.gmail.com>
	 <20090429193744.GA17797@mit.edu>
	 <6601abe90904291321u3f13d8b0p88b9a9eba5bc03a1@mail.gmail.com>
	 <20090429212043.GB24749@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:52612 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbZEDPwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2009 11:52:11 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id n44FqAk8029600
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 08:52:10 -0700
Received: from gv-out-0910.google.com (gveo2.prod.google.com [10.16.166.2])
	by wpaz24.hot.corp.google.com with ESMTP id n44Fq6dv006924
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 08:52:07 -0700
Received: by gv-out-0910.google.com with SMTP id o2so38556gve.22
        for <linux-ext4@vger.kernel.org>; Mon, 04 May 2009 08:52:06 -0700 (PDT)
In-Reply-To: <20090429212043.GB24749@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

On Wed, Apr 29, 2009 at 2:20 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Apr 29, 2009 at 01:21:09PM -0700, Curt Wohlgemuth wrote:
>>
>> Hmm, I thought I attached the output from "e2fsck -E fragcheck"; yes=
,
>> I did: one simple line:
>>
>> =A0 =A0 =A0 =A0 /dev/hdm3: clean, 14/45760512 files, 7608255/1830104=
71 blocks
>
> Sorry, I should have been more explicit. =A0 You need to do
>
> "e2fsck -f -E fragcheck", and you will get a *heck* of a lot more tha=
n
> a single line. =A0:-)
>
>> And actually, I created the files sequentially:
>>
>> dd if=3D/dev/zero of=3D$MNT_PT/4g bs=3D1G count=3D4
>> dd if=3D/dev/zero of=3D$MNT_PT/4g-2 bs=3D1G count=3D4
>> dd if=3D/dev/zero of=3D$MNT_PT/10g bs=3D1G count=3D10
>
> Really? =A0Hmm, I wouldn't have expected that. =A0So now I'd really l=
ove
> to see the fragcheck results (both with and without the patch), and/o=
r
> the results of debugfs stat'ing all three files, both with and withou=
t
> the patch.

Although it might seem like I've been ignoring this request, in fact
I'm having trouble recreating the problem now.  Both the "three dd"
commands above, and the performance problem I was seeing in the
original posting seem to have mysteriously disappeared.  I'll keep
trying and let the list know what I find.

Thanks,
Curt

>
> Thanks,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
