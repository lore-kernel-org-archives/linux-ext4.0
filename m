From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] allocate struct ext4_allocation_context from a
	kmem	cache to save stack space
Date: Thu, 07 Feb 2008 17:37:16 -0800
Message-ID: <1202434636.3840.25.camel@localhost.localdomain>
References: <47A9E8CA.2070404@redhat.com>
	 <1202429513.3840.12.camel@localhost.localdomain>
	 <47ABAB29.2060300@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40271 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623AbYBHBhU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2008 20:37:20 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m181bGB5018509
	for <linux-ext4@vger.kernel.org>; Thu, 7 Feb 2008 20:37:16 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m181bFuS239886
	for <linux-ext4@vger.kernel.org>; Thu, 7 Feb 2008 20:37:15 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m181bFUN029059
	for <linux-ext4@vger.kernel.org>; Thu, 7 Feb 2008 20:37:15 -0500
In-Reply-To: <47ABAB29.2060300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-02-07 at 19:06 -0600, Eric Sandeen wrote:
> Mingming Cao wrote:
> 
> > Do you intend to remove the #ifdef CONFIG_PROC_FS, or it's a accident? I
> > think we need keep that to allow ext4 build without procfs configured.
> > 
> > Other than this, the patch looks fine to me.:)
> 
> oh, it kind of snuck in.  It actually should still build, as
> remove_proc_entry is a no-op function w/o the config option.

Oh, I mean the proc_mkdir(EXT4_ROOT, proc_root_fs) will complain w/o
CONFIG_PROC_FS configured.

Mingming
