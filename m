From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH UPDATED] jbd: Use printk_ratelimited() in
 journal_alloc_journal_head()
Date: Mon, 04 Oct 2010 21:20:04 +0900
Message-ID: <1286194804.1664.7.camel@leonhard>
References: <20101004094331.GC3589@quack.suse.cz>
	 <1286187133-12475-1-git-send-email-namhyung@gmail.com>
	 <20101004103145.GG3589@quack.suse.cz> <20101004113751.GA7982@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38319 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0JDMUM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Oct 2010 08:20:12 -0400
In-Reply-To: <20101004113751.GA7982@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010-10-04 (=EC=9B=94), 13:37 +0200, Jan Kara:
>   Grumble, you apparently didn't try to compile the thing... The patc=
h
> was missing #include <linux/ratelimit.h>. I've fixed that up now. Ple=
ase be
> more careful next time. Thanks.
>=20
>  								Honza

Egads, I did compile-test but I forgot I did make allnoconfig before.
(And then I added ext3 support manually.) I'll double check a patch
before sending it in the future. Sorry for the inconvenience.

Thanks.

--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
