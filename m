From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: [PATCH] Fix ext2fs_set_gdt_csum() to use access functions.
Date: Thu, 3 Sep 2009 11:16:38 -0700
Message-ID: <150c16850909031116l15c6b728ld43a9a38c94a3bc@mail.gmail.com>
References: <12386.1251948115@gamaville.dokosmarshall.org> <sandeen@redhat.com>
	 <4A9F4B57.9080602@redhat.com>
	 <15737.1251954670@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:61133 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbZICSWr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 14:22:47 -0400
Received: by pzk28 with SMTP id 28so110709pzk.27
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2009 11:22:50 -0700 (PDT)
In-Reply-To: <15737.1251954670@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 2, 2009 at 10:11 PM, Nick Dokos<nicholas.dokos@hp.com> wrote:
>
> Thanks for looking it over and testing too! We'll see whether Justin's
> problem disappears.

Yes, it did!  Thanks everyone for taking the time to look into this
and get out a fix!

-Justin
