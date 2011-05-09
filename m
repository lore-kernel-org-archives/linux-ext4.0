From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: errors in ext4_mb_generate_buddy and ext4_remount
Date: Mon, 09 May 2011 14:55:52 +0200
Message-ID: <1304945752.11788.11.camel@heisenberg.scientia.net>
References: <f93bc5d54d25e080b5438bcdc3af8f84@imap.dd24.net>
	 <20110509010112.GC4138@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw02.dd24.net ([193.46.215.43]:36570 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1EIMzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 08:55:51 -0400
Received: from localhost (amavis02.dd24.net [192.168.1.113])
	by mailgw02.dd24.net (Postfix) with ESMTP id 52A1F35546B
	for <linux-ext4@vger.kernel.org>; Mon,  9 May 2011 12:55:50 +0000 (GMT)
Received: from mailgw02.dd24.net ([192.168.1.197])
	by localhost (amavis02.dd24.net [192.168.1.106]) (amavisd-new, port 10197)
	with ESMTP id 2NRi8MmoTq40 for <linux-ext4@vger.kernel.org>;
	Mon,  9 May 2011 12:55:46 +0000 (GMT)
Received: from heisenberg.scientia.net (unknown [141.84.43.125])
	by mailgw02.dd24.net (Postfix) with ESMTPA id 331AF355466
	for <linux-ext4@vger.kernel.org>; Mon,  9 May 2011 12:55:46 +0000 (GMT)
In-Reply-To: <20110509010112.GC4138@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted.

On Sun, 2011-05-08 at 21:01 -0400, Ted Ts'o wrote:
> Kernels 2.6.35 and newer will set superblock fields that will result
> in those messages.  They're not error messages per se; it's just a
> notification that there was an file system error in the past that
> hasn't been fixed yet.  In your case, it *has* been fixed, but you
> don't have a new enough version of e2fsprogs so that it clears the
> relevant parts of the superblock.
Thanks for that explanation.

> The debian packages of e2fsprogs version 1.41.14-1 in experimental, o=
r
> 1.41.12-4 in unstable
Ah, I haven't tried it with the one that was uploaded to unstable
yet.... will give it a try later.


Another thing. Perhaps you've seen my post where I've unfortunately
overridden an (important ;) ) ext3 fs with mkfs, instead of doing fsck.

Of course this is my fault but do you see any chance to add checks to
mke2fs whether any known fs/partition type/other containter like
luks/mdadm/etc. is on the device? (And of course require a
--force=3DI-really-know-what-I-do=E2=84=A2 parameter to the evil.)

Cheers,
Chris.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
