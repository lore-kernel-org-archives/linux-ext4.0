From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Making it easier for end users to use ext4
Date: Tue, 15 Jul 2008 07:22:36 +0200
Message-ID: <873ambwwkj.fsf@frosties.localdomain>
References: <E1KITeX-0001PV-Pv@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:55599 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYGOFWi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 01:22:38 -0400
In-Reply-To: <E1KITeX-0001PV-Pv@closure.thunk.org> (Theodore Ts'o's message of
	"Mon, 14 Jul 2008 15:24:05 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Ts'o" <tytso@mit.edu> writes:

> So I got a comment on my recent blog posting about using ext4 that
> Googling ext4 results in a lot of ancient status reports and not a lot
> of good information about how to get started with ext4.  The comment was
> fair, so I took a few minutes to update this web page:
>
>       http://ext4.wiki.kernel.org/index.php/Ext4_Howto
>
> with some getting started information.

Many thanks. Going through various pages I found the information to be
seriously out of date ranging from one to two years.

Some thoughts about missing bits from a first read through:

Getting Ext4 code:
- add ext4 and e2fsprogs git repositories
- Add Debian section

64 bit block support:
- limits without it
- state of it
- where to get patches

MfG
        Goswin
