From: Albino B Neto <bino@riseup.net>
Subject: Re: [PATCH] Fix style and return NULL
Date: Mon, 21 Sep 2015 15:24:56 -0300
Message-ID: <CAMu38xJEgUBq0uT5tt3VxUWkKaaFknrUK3wV1Qhe-Z5KtB35Rw@mail.gmail.com>
References: <tytso@mit.edu>
	<1442613662-5100-1-git-send-email-bino@riseup.net>
	<20150919034848.GD2921@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:43345 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821AbbIUSY6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Sep 2015 14:24:58 -0400
Received: from cotinga.riseup.net (unknown [10.0.1.161])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
	by mx1.riseup.net (Postfix) with ESMTPS id E3D3CC33C6
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2015 11:24:57 -0700 (PDT)
Received: by qgez77 with SMTP id z77so97329523qge.1
        for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2015 11:24:56 -0700 (PDT)
In-Reply-To: <20150919034848.GD2921@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2015-09-19 0:48 GMT-03:00 Theodore Ts'o <tytso@mit.edu>:
> Please don't try to correct "style" --- in fact, you've made things
> worse, and in fact, you've introduced compile errors when tried to fix
> "style".
>
> You also apparently didn't bother to check and see if the patch
> compiled correctly.  Please *do* try to make sure you have (a) tested
> your patches to make sure that they compile, and (b) at the very
> *minimum* tested your patch to make sure that any code paths you have
> changed has been exercised.
>
> In addition, it is highly preferable that for ext4 changes that you
> have tested them using kvm-xfstests[1] or gce-xfstests[2] before
> submitting a patch.  This may seem like a lot of extra work, but
> unlike other parts of the kernel, if you just make the kernel crash,
> it will annoy users --- but if you corrupt their data, they users tend
> to get really steamed, so we have somewhat higher standards in file
> system code.
>
> Of course, if your changes cause the kernel to not even compile, users
> aren't at risk of losing their data; but then you tend to annoy your
> fellow kernel developers.  :-)
>
>
> [1] https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/plain/quick-start?h=META
> [2] https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/README.GCE

Thank for help.

  Albino
