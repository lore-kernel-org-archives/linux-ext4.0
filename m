From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 14843] New: WARNING: at mm/page_alloc.c at ext4 root mount
Date: Tue, 22 Dec 2009 15:39:36 -0800
Message-ID: <20091222153936.269e8153.akpm@linux-foundation.org>
References: <bug-14843-27@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbZLVXjj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Dec 2009 18:39:39 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id nBMNdb2x011476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Dec 2009 15:39:38 -0800
Received: from akpm.mtv.corp.google.com (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id nBMNdaNN031170
	for <linux-ext4@vger.kernel.org>; Tue, 22 Dec 2009 15:39:37 -0800
In-Reply-To: <bug-14843-27@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 19 Dec 2009 16:12:52 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14843
> 
>            Summary: WARNING: at mm/page_alloc.c at ext4 root mount
>            Product: Memory Management
>            Version: 2.5
>     Kernel Version: 2.6.33-rc1
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Page Allocator
>         AssignedTo: akpm@linux-foundation.org
>         ReportedBy: casteyde.christian@free.fr
>         Regression: Yes
> 
> 
> Kernel 2.6.33-rc1 64bits with kmemcheck and other debug options
> Athlon64 3GHz single core
> Acer Aspire 1511LMi
> Bluewhite 64 13 (32 bits port of Slackware)
> 
> Since 2.6.33-rc1, I get the following warning at boot when the root ext4
> filesystem is mounted:
> kmemleak: Automatic memory scanning thread started
> EXT3-fs (hda2): error: couldn't mount because of unsupported optional features
> (240)
> EXT2-fs (hda2): error: couldn't mount because of unsupported optional features
> (240)
> ------------[ cut here ]------------
> WARNING: at mm/page_alloc.c:1220 get_page_from_freelist+0x6a4/0x6c0()

Can we please zap that __GFP_NOFAIL in journal_init_common()?
