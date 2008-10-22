From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [stable] [PATCH] stable - ext[234]: Avoid printk floods in the
 face of directory corruption (CVE-2008-3528)
Date: Wed, 22 Oct 2008 14:33:55 -0500
Message-ID: <48FF8023.4010108@redhat.com>
References: <48FF42B8.3030606@redhat.com> <20081022161433.GB29489@kroah.com> <48FF52F4.10702@redhat.com> <20081022163421.GA28836@kroah.com> <48FF644A.50801@redhat.com> <20081022173752.GA10587@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: stable@kernel.org, ext4 development <linux-ext4@vger.kernel.org>
To: Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49725 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYJVTeG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2008 15:34:06 -0400
In-Reply-To: <20081022173752.GA10587@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg KH wrote:

> Yes, the fun "physical access" issue, right?
> 
> But for some, who run Linux in a "kiosk" mode, or in semi-secured places
> like university labs, something like this would matter, so you might
> want to notify the distros of this issue through vendor-sec and let them
> make up their minds if they wish to backport the fixes to their
> supported releases.

Well, the CVE should do that, right... distro security teams should be
looking at the CVEs.

-Eric
