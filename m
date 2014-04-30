From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] libext2fs: fix alloc_allocate_group_table() if the
 flexbg_offset wraps
Date: Tue, 29 Apr 2014 22:34:14 -0400
Message-ID: <20140430023414.GC6714@thunk.org>
References: <1398694179-18027-1-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1404291259500.2183@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40971 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaD3CeS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2014 22:34:18 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404291259500.2183@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 29, 2014 at 01:02:07PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> Not sure about this, but I just wonder whether this would work with
> bigalloc file system as well since it is true that we're testing
> blocks in this condition but in ext2fs_test_block_bitmap_range2()
> we're searching for a free cluster.

No, we're fine because the bitmap functions takes block numbers as
arguments, not cluster numbers.  (The bitmap functions converts block
numbers to cluster numbers, and there's a special hack for mke2fs so
we don't burn a separate cluster for each allocation bitmap block.)

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
