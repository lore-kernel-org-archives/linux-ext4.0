From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext3 warnings from LTP rename14
Date: Thu, 18 Oct 2007 09:43:34 -0500
Message-ID: <47177116.5070705@redhat.com>
References: <20071017002009.GA2966@palantir8> <4715637B.1090503@redhat.com> <471570CB.3030709@redhat.com> <20071018060850.GN8122@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758272AbXJROni (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 10:43:38 -0400
In-Reply-To: <20071018060850.GN8122@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:

> It is probably significant that the original machine is a sparc32 (big
> endian).  

Oh, true.

> I'd suspect you can reproduce this on a PPC system also.  You
> might also consider running sparse on it ext3/ext4 in case you missed an
> le32_to_cpu() or something.

sparse checks out ok... and, -rc6 which did not have that change showed
the same behavior....

-Eric
