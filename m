From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11964] New: JBD: grub-probe wants too many
 credits (266 > 256)
Date: Thu, 6 Nov 2008 14:15:33 -0800
Message-ID: <20081106141533.bc88e0f1.akpm@linux-foundation.org>
References: <bug-11964-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbYKFWQE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 17:16:04 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA6MFXDH010527
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 14:15:34 -0800
Received: from akpm.corp.google.com (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id mA6MFX6M018353
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 14:15:33 -0800
In-Reply-To: <bug-11964-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu,  6 Nov 2008 13:34:28 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> Subject: [Bugme-new] [Bug 11964] New: JBD: grub-probe wants too many credits (266 > 256)

Well that was confusing.  The "JBD:" text had me thinking that it
was an ext3 bug, but it is in fact ext4-only.

Shouldn't we do s/JBD/JBD2/g in there?
