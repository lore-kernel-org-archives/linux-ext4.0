From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: tracepoints in ext4 (and/or ext3?)
Date: Tue, 12 Aug 2008 11:13:55 +0900
Message-ID: <20080812110833.946B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <48A09E7F.7060605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: kosaki.motohiro@jp.fujitsu.com,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59350 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYHLCOn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2008 22:14:43 -0400
In-Reply-To: <48A09E7F.7060605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> As just an initial inquiry, I'm wondering how people would feel about
> putting some tracepoints (trace_mark()) into ext[34] for monitoring the
> fs behavior.
> 
> Good/bad/indifferent?

I think tracepoint on ext[34] is very good idea :)


