From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
Date: Sun, 11 Oct 2009 16:11:20 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0910111608490.3438@localhost.localdomain>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Natalie Protasevich <protasnb@gmail.com>,
	linux-ext4@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbZJKXPO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Oct 2009 19:15:14 -0400
In-Reply-To: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mon, 12 Oct 2009, Rafael J. Wysocki wrote:
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14370
> Subject		: ext4 corruptions
> Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> Date		: 2009-10-09 19:20 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=125511643504864&w=4
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14354
> Subject		: Bad corruption with 2.6.32-rc1 and upwards
> Submitter	: Holger Freyther <zecke@selfish.org>
> Date		: 2009-10-09 15:42 (3 days old)

These two look like duplicates to me. No?

			Linus
