From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: OOPs in ext4
Date: Wed, 21 May 2014 17:14:23 +0200
Message-ID: <CAOkSjBhRk3KOWXJeApi9TvgQVSP0eudZYkTdakDrC8uzUS-4Lg@mail.gmail.com>
References: <CAOkSjBgTFq_LnYnctOj2zR_to47joQDDbft3-kjEGzd2=ooswg@mail.gmail.com>
 <alpine.LFD.2.00.1405211506190.2114@localhost.localdomain>
 <20140521145315.GA8868@thunk.org> <CAOkSjBgXt-Ju3q+yNM13jx2UccDspJCAPZgd=vDyYYMo_kO_BQ@mail.gmail.com>
 <alpine.LFD.2.00.1405211711470.2114@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42981 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaEUPOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2014 11:14:45 -0400
Received: by mail-lb0-f177.google.com with SMTP id s7so1641829lbd.8
        for <linux-ext4@vger.kernel.org>; Wed, 21 May 2014 08:14:44 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1405211711470.2114@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 21 May 2014 17:12, Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com> wro=
te:
> On Wed, 21 May 2014, Arturo Borrero Gonzalez wrote:
>
>> Date: Wed, 21 May 2014 17:06:56 +0200
>> From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
>> To: Theodore Ts'o <tytso@mit.edu>
>> Cc: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>, linux-ext4@vger.k=
ernel.org
>> Subject: Re: OOPs in ext4
>>
>> On 21 May 2014 16:53, Theodore Ts'o <tytso@mit.edu> wrote:
>> > Also, after the system rebooted, what messages if any did e2fsck
>> > report?
>> >
>>
>> Unfortunately, my e2fsck is translated to spanish. I will do my best
>> to translate the report to english.
>
> you can run:
>
> LANG=3DC e2fsck -nf /dev/vda1

well, thanks.

e2fsck 1.42.5 (29-Jul-2012)
Warning!  /dev/vda1 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem=
 check.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
=46ree blocks count wrong (5721853, counted=3D5579605).
=46ix? no

=46ree inodes count wrong (2348360, counted=3D2348351).
=46ix? no

/dev/vda1: 273080/2621440 files (0.8% non-contiguous), 4763651/10485504=
 blocks

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
