From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: OOPs in ext4
Date: Wed, 21 May 2014 17:06:56 +0200
Message-ID: <CAOkSjBgXt-Ju3q+yNM13jx2UccDspJCAPZgd=vDyYYMo_kO_BQ@mail.gmail.com>
References: <CAOkSjBgTFq_LnYnctOj2zR_to47joQDDbft3-kjEGzd2=ooswg@mail.gmail.com>
 <alpine.LFD.2.00.1405211506190.2114@localhost.localdomain> <20140521145315.GA8868@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35154 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaEUPHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2014 11:07:18 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so1679959lbg.4
        for <linux-ext4@vger.kernel.org>; Wed, 21 May 2014 08:07:16 -0700 (PDT)
In-Reply-To: <20140521145315.GA8868@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 21 May 2014 16:53, Theodore Ts'o <tytso@mit.edu> wrote:
> Also, after the system rebooted, what messages if any did e2fsck
> report?
>

Unfortunately, my e2fsck is translated to spanish. I will do my best
to translate the report to english.

root@debian:~# e2fsck -nf /dev/vda1
e2fsck 1.42.5 (29-Jul-2012)
Warning!  /dev/vda1 is mounted.
Warning: no repair will be done to the transactions file, given the
check is read only.
Step 1: Checking inodes, blocks and sizes
Step 2: Checking dirs tree
Step 3: Checking dirs connectivity
Step 4: Checking refcounts
Step 5: Checking group info

The free blocks count is incorrect (5721853, counted=3D5579610).
=C2=BFFix? no

The free i-nodes count is incorrect (2348360, counted=3D2348351).
=C2=BFFix? no

/dev/vda1: 273080/2621440 files (0.8% non-contiguous), 4763651/10485504=
 blocks

regards
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
