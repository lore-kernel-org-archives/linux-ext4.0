From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Mon, 5 Apr 2010 13:08:58 +0800
Message-ID: <o2tac8f92701004042208l99c70297mf9955beacacd96bf@mail.gmail.com>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
	 <87sk7nv4sp.fsf@linux.vnet.ibm.com>
	 <x2vac8f92701003280113k2458fcb6mefe6c04875c9b3a3@mail.gmail.com>
	 <20100403165340.GA17819@thunk.org>
	 <j2tac8f92701004031805s9b09d04csc5adf5199dc9b9a7@mail.gmail.com>
	 <20100404180845.GG18524@thunk.org>
	 <v2oac8f92701004042053p1738ece4u299dcb481b2fc3f2@mail.gmail.com>
	 <4BB966AE.1060207@redhat.com>
	 <t2pac8f92701004042151x3b0c27e2h805778b7b3aeefba@mail.gmail.com>
	 <4BB96E14.9010903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f191.google.com ([209.85.210.191]:61720 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0DEFI7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Apr 2010 01:08:59 -0400
Received: by yxe29 with SMTP id 29so1930545yxe.4
        for <linux-ext4@vger.kernel.org>; Sun, 04 Apr 2010 22:08:58 -0700 (PDT)
In-Reply-To: <4BB96E14.9010903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/4/5, Eric Sandeen <sandeen@redhat.com>:
> Testing really is critical to development; some things can be done by
> inspection, but if you don't test it is hard to know if you made a
> mistake.
>
> You can always test inside a vm, or on a loopback file, on a single box.
>
> Without testing, you are asking others to do testing for you
> (unless the change is so obvious that it can be trusted)
>

Before linux-2.6.32 is released, would you like tell me, how is ext4 tested?
Is tough testing able to catch all bugs?

      - zj
