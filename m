From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [PATCH 0/5][64-BIT] Miscellaneous e2fsprogs 64-bit patches - description
Date: Wed, 15 Apr 2009 17:51:07 -0400
Message-ID: <8298.1239832267@alphaville.usa.hp.com>
References: <11629.1239227147@alphaville.usa.hp.com>  <20090415195014.GB1668@shell>
Reply-To: nicholas.dokos@hp.com
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:26040 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZDOVu5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Apr 2009 17:50:57 -0400
In-Reply-To: Message from Valerie Aurora Henson <vaurora@redhat.com>
   of "Wed, 15 Apr 2009 15:50:14 EDT." <20090415195014.GB1668@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Aurora Henson <vaurora@redhat.com> wrote:

> Thanks for the testing and patches!  I apologize for the delay in
> replying; if it's any consolation, we were all at the Linux file
> systems workshop when you sent this email.
> 
> All the patches look good to me (and I will ACK them individually).  I
> pulled them into my shared-64bit branch at:
> 
> http://git.kernel.org/?p=fs/ext2/val/e2fsprogs.git;a=summary
> 

Val,

Thanks for the feedback (no problem about the delay: I really was not
expecting a response last week).

I should add a caution that these were (mostly) problems that arose in
testing and I tried to fix them (and only them: e.g., in a subsequent
email you found a place where a blk_t should be a blk64_t: there are
probably *many other* such places); in particular, there is no pretense
of a complete and thorough code audit - that still needs to be done and
I'm trying to do it, but I'm not there yet.

Thanks,
Nick

