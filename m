From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: merging of two file system
Date: Thu, 07 Aug 2008 14:12:00 +0200
Message-ID: <873alh6n3j.fsf@frosties.localdomain>
References: <425904320807270905k32264faaq5c813b73000ee5c6@mail.gmail.com>
	<488D0267.4070202@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vineet Agarwal <checkout.vineet@gmail.com>,
	linux-ext4@vger.kernel.org, listar@nl.linux.org
To: Shehjar Tikoo <shehjart@cse.unsw.edu.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:53175 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYHGMpl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Aug 2008 08:45:41 -0400
In-Reply-To: <488D0267.4070202@cse.unsw.edu.au> (Shehjar Tikoo's message of
	"Mon, 28 Jul 2008 09:19:03 +1000")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Shehjar Tikoo <shehjart@cse.unsw.edu.au> writes:

> Vineet Agarwal wrote:
>> can we merge two file system into one in ext2/3 ?
>>
>
> UnionFS might be what you're looking for.
>
> -Shehjar

I prefer unionfs fuse. When merging directories on NFS the kernel
unionFS would oops when someone changed files on the server. Verry
nasty.

MfG
        Goswin
