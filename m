From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: 32TB ext4 fsck times
Date: Thu, 23 Apr 2009 02:01:16 -0400
Message-ID: <10808.1240466476@gamaville.dokosmarshall.org>
References: <10039.1240286799@gamaville.dokosmarshall.org> <49EE1F06.5040508@redhat.com>  <20090422231816.GA7066@shell>
Reply-To: nicholas.dokos@hp.com
Cc: Ric Wheeler <rwheeler@redhat.com>, nicholas.dokos@hp.com,
	linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:41686
	"EHLO QMTA15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbZDWGBZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Apr 2009 02:01:25 -0400
In-Reply-To: Message from Valerie Aurora Henson <vaurora@redhat.com>
   of "Wed, 22 Apr 2009 19:18:16 EDT." <20090422231816.GA7066@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Aurora Henson <vaurora@redhat.com> wrote:

> Back to something useful the short term... Was the file system created
> with uninitialized block groups and lazy inode table initialization?
> 

Uninit_bg was on but lazy inode table initialization was off.  I tried
turning lazy_itable_init on but e2fsck gets tons of errors, starting
with group descriptor checksum errors.  Unfortunately, I now get group
descriptor checksum errors even without lazy_itable_init and I 'm not
sure why. So I'm back to debugging mke2fs/e2fsck.

Nick
