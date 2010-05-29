From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: Is >16TB support considered stable?
Date: Sat, 29 May 2010 14:32:57 +1000
Message-ID: <87ljb3gwee.fsf@willster.local.flamingspork.com>
References: <4BFFF4D2.6020908@van-ness.com> <4C001BEC.9080906@redhat.com> <4C00804D.7010000@van-ness.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sandon Van Ness <sandon@van-ness.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kaylee.flamingspork.com ([74.207.245.61]:38085 "EHLO
	kaylee.flamingspork.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0E2EnT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 May 2010 00:43:19 -0400
In-Reply-To: <4C00804D.7010000@van-ness.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 28 May 2010 19:47:41 -0700, Sandon Van Ness <sandon@van-ness.com> wrote:
> able to allocate blocks or memory (it was a while back so I forget). I
> spent 24 hours defraging it getting the fragmentation down from like
> 99.9995% to 99.2% and the problem went away. XFS seems to excessively
> fragment (that horribly fragmented system was running mythtv and after
> switching to JFS I see way less fragmented files).

MythTV's IO path is well... hacked to get around all of ext3's quirks.

You can:
- mount XFS with allocsize=64m (or similar)
- possibly use the XFS filestreams allocator
- comment out the fsync() in the mythtv tree
- LD_PRELOAD libeatmydata for myth.

it turns out that writing a rather small amount of data and fsync()ing
(and repeating 1,000,000 times) makes the allocator cry a bit with
default settings. Especially if you were recording a few things at once.

-- 
Stewart Smith
