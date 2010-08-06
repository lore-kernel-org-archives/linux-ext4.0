From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Fri, 06 Aug 2010 19:44:17 +0200
Message-ID: <E1OhQxt-0006Nx-HT@pomaz-ex.szeredi.hu>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com> <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu> <20100804224831.GB29353@shell> <E1Ogxol-0002xs-De@pomaz-ex.szeredi.hu> <20100805233019.GA30761@shell> <E1OhI5C-0005PG-3G@pomaz-ex.szeredi.hu> <20100806171640.GC16599@shell>
Cc: miklos@szeredi.hu, viro@zeniv.linux.org.uk, jblunck@suse.de,
	hch@infradead.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34693 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab0HFRog (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2010 13:44:36 -0400
In-reply-to: <20100806171640.GC16599@shell> (message from Valerie Aurora on
	Fri, 6 Aug 2010 13:16:40 -0400)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 6 Aug 2010, Valerie Aurora wrote:
> Oh, "mmount -b 8" == "mount -o union".

Right.

>   Is this the mmount from mtools
> or something else?

It's primitive utility that basically just wraps the mount(2) syscall
without any fstab/mtab support:

  http://www.kernel.org/pub/linux/kernel/people/mszeredi/mmount/

Miklos
