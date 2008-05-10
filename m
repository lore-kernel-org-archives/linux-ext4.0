From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] jbd: tidy up revoke cache initialisation and
 destruction
Date: Fri, 9 May 2008 17:42:59 -0700
Message-ID: <20080509174259.4582008e.akpm@linux-foundation.org>
References: <1209833235-30521-1-git-send-email-duaneg@dghda.com>
	<1209833235-30521-2-git-send-email-duaneg@dghda.com>
	<1209833235-30521-3-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, cmm@us.ibm.com, sct@redhat.com,
	linux-ext4@vger.kernel.org, duaneg@dghda.com
To: "Duane Griffin" <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756124AbYEJAnm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2008 20:43:42 -0400
In-Reply-To: <1209833235-30521-3-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat,  3 May 2008 17:47:14 +0100
"Duane Griffin" <duaneg@dghda.com> wrote:

> Make revocation cache destruction safe to call if initialisation fails
> partially or entirely. This allows it to be used to cleanup in the case of
> initialisation failure, simplifying that code slightly.

This crashes the kernel early in boot.  Too early to catch via netconsole,
which is a bit odd.

I also have a feeling that [patch 1/3] causes problems too but I've run out
of time to bisect it further.

