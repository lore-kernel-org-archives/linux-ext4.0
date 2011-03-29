From: Christian Brandt <brandtc@psi5.com>
Subject: Re: fsck.ext4 taking months
Date: Tue, 29 Mar 2011 22:21:41 +0200
Message-ID: <4D923F55.1010507@psi5.com>
References: <4D8F1F75.8010201@psi5.com> <4D909E92.4080209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:59304 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1C2UVn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 16:21:43 -0400
In-Reply-To: <4D909E92.4080209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am 28.03.2011 16:43, schrieb Ric Wheeler:

> Sounds like a configuration that might well require lots of memory to
> cache your allocated inodes, etc. How much memory do you have in the
> box running fsck? Any sense (vmstat, etc) what the box is spending
> its time doing?

 100% CPU use as seen in top and ps.

 The first System had 1GB and the process used 680MB, a plain Ubuntu
with nothing else running.

 I tried another system with 4GB, at least 3GB free, the process still
uses only 680MB. Booted from a Knoppix-CD, nothing running except fsck,
vmstat says:

procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 1  0      0 1573456 797988 776484    0    0    13     8    7   18 41  5
53  2

-- 
Christian Brandt

 life is short and in most cases it ends with death
 but my tombstone will carry the hiscore
