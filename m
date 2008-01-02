From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Date: Wed, 2 Jan 2008 21:21:43 +0000
Message-ID: <20080102212143.01cb82bd@the-village.bc.nu>
References: <20080102013218.GO27566@does.not.exist>
	<20080102192629.28e67241.diegocg@gmail.com>
	<20080102211655.GC15898@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Diego Calleja <diegocg@gmail.com>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57840 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753697AbYABVbU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2008 16:31:20 -0500
In-Reply-To: <20080102211655.GC15898@does.not.exist>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Stable kernels are mainly meant for usage, not for trying stuff.

You appear to be reinventing history in your attempt to justify removing
CONFIG_EXPERIMENTAL.

> And although I see a point in perhaps shipping some not-yet-perfect 
> device drivers for otherwise unsupported hardware or some
> not-yet-perfect filesystems required for accessing foreign
> (non-Linux) filesystems, I don't see any point in offering a
> WIP Linux-only filesystem in stable kernels.

So that people can use it and test it. Most people don't run -mm or GIT.

Alan
