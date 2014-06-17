From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Tue, 17 Jun 2014 10:53:21 -0700
Message-ID: <CAKP4w2QSUYYFVeM2_a7iMybnad_A27WEx3K=qiMf-_namjvS-A@mail.gmail.com>
References: <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard> <20140613142054.GA23180@thunk.org>
 <20140613143157.GB23180@thunk.org> <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <20140613234134.GC5036@thunk.org> <20140617024953.GG9508@dastard>
 <alpine.LFD.2.00.1406171346570.2148@localhost.localdomain>
 <20140617124629.GA13868@thunk.org> <alpine.LFD.2.00.1406171449000.2148@localhost.localdomain>
 <20140617135405.GA5054@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:64929 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992AbaFQRxm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2014 13:53:42 -0400
Received: by mail-oa0-f50.google.com with SMTP id n16so9500837oag.9
        for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2014 10:53:41 -0700 (PDT)
In-Reply-To: <20140617135405.GA5054@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 17, 2014 at 6:54 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> There's an assumption here that the eMMC SECDISCARD functionality is
> more competently spec'ed out compared to the ATA/SCSI interface.  I'm
> not sure whether or not that's true, but perhaps JP and Geremy can
> confirm that.
We only care about the eMMC spec. In the eMMC spec there is no room
for ignoring the commands. If the card declares it can do a secure
erase/trim it must do it as per the spec.
  JEDEC Standard No. 84-A441
  7.6.9 Secure Erase
  7.6.10 Secure Trim
