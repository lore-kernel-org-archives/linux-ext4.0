From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [EXT2] Discard unused sectors
Date: Thu, 14 Aug 2008 10:05:48 +0100
Message-ID: <1218704748.4620.50.camel@pmac.infradead.org>
References: <1218704379.4620.46.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439AbYHNJFu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 05:05:50 -0400
Received: from pmac.infradead.org ([2001:8b0:10b:1:20d:93ff:fe7a:3f2c])
	by bombadil.infradead.org with esmtpsa (Exim 4.68 #1 (Red Hat Linux))
	id 1KTYmE-00038w-8y
	for linux-ext4@vger.kernel.org; Thu, 14 Aug 2008 09:05:50 +0000
In-Reply-To: <1218704379.4620.46.camel@pmac.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm not sure how to do this for ext[34]. The sb_issue_discard() functio=
n
issues its requests as a soft barrier, because for na=C3=AFve callers i=
t
needs to ensure that the discard happens _before_ any subsequent writes
to the same sectors (if they get reallocated immediately).

But ext[34] can probably do better than that, and submit the discard
requests _without_ barriers of their own. If someone with a bit more
clue does it, that is.

--=20
David Woodhouse                            Open Source Technology Centr=
e
David.Woodhouse@intel.com                              Intel Corporatio=
n



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
