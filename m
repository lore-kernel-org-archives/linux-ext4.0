From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] types fixup for mballoc
Date: Thu, 15 Nov 2007 22:49:11 -0600
Message-ID: <473D2147.9030504@redhat.com>
References: <473CCEB8.5060201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbXKPEtQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2007 23:49:16 -0500
In-Reply-To: <473CCEB8.5060201@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> I ran into a potential overflow in ext4_mb_scan_aligned, 
> and went looking for others in mballoc.  This patch hits a 
> few spots, compile-tested only at this point, comments welcome.
> 
> This patch:
> 

... introduces a 64-bit divide.  Oops... will fix that up & resend.

-Eric
