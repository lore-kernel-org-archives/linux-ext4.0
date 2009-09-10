From: Stephan Kulow <coolo@suse.de>
Subject: Re: buggy_init_scritps and e2fsprogs 1.41.9
Date: Thu, 10 Sep 2009 15:03:18 +0200
Message-ID: <200909101503.18497.coolo@suse.de>
References: <200909101455.38400.coolo@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40381 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572AbZIJNDQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 09:03:16 -0400
Received: from relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id E0E875362F
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 15:03:18 +0200 (CEST)
In-Reply-To: <200909101455.38400.coolo@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Donnerstag 10 September 2009 sent Stephan Kulow:
> 
> The release notes of 1.41.9 talk only about the exact opposite
> case: "Fix e2fsck's buggy_init_scritps=1 so that the if the last
> write and/or last mount times are in the future, they are corrected
> even if buggy_init_scripts is set."
> 
If I read the code correctly, the problem is that time_fudge is 0 for 
buggy_init_scripts=0 and as such there is no difference between
PR_0_FUTURE_SB_LAST_MOUNT_FUDGED and PR_0_FUTURE_SB_LAST_MOUNT
and so openSUSE always falls into the PR_0_FUTURE_SB_LAST_MOUNT

-> no PR_PREEN_OK

Greetings, Stephan
