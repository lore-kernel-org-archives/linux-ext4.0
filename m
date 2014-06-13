From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Fri, 13 Jun 2014 13:12:25 -0700
Message-ID: <CAKP4w2TXaZeS7jS8oOGWaiWkTOw2beKEmy-4QH73iduCHT48Ew@mail.gmail.com>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com> <20140613031538.GR4453@dastard>
 <20140613033029.GS4453@dastard> <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com>
 <20140613050703.GT4453@dastard> <20140613142054.GA23180@thunk.org>
 <20140613143157.GB23180@thunk.org> <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
 <539B579F.5000403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40715 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaFMUMp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2014 16:12:45 -0400
Received: by mail-ob0-f177.google.com with SMTP id uy5so3218473obc.36
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2014 13:12:45 -0700 (PDT)
In-Reply-To: <539B579F.5000403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2014 at 12:57 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> I don't know what device you're running on,

At least Nexus devices that will get updates. :)

> but figured it might
> be worth pointing out that not all hardware even supports this
> capability.

True.
For future devices, the feature will be for certain eMMC devices,
certain kernels, certain FSes only. All stuff that we don't control,
but we can give advice on.
