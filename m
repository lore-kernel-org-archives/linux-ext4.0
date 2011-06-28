From: "Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS]"
	<sean.d.mccauliff@nasa.gov>
Subject: RE: High CPU Utilization When Copying to Ext4
Date: Tue, 28 Jun 2011 15:20:39 -0500
Message-ID: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA1270A@NDJSSCC06.ndc.nasa.gov>
References: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov>,<20110627030539.GF3064@thunk.org>
 <341DAA96EE3A8444B6E4657BE8A846EA4B3DA12708@NDJSSCC06.ndc.nasa.gov>,<F673734C-4ECE-40B2-B283-959027C34B06@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ndjsnpf03.ndc.nasa.gov ([198.117.1.123]:57174 "EHLO
	ndjsnpf03.ndc.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab1F1UkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 16:40:25 -0400
In-Reply-To: <F673734C-4ECE-40B2-B283-959027C34B06@mit.edu>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Last time I benchmarked cp and tar with the respective sparse file options they where extremely slow as they (claim) to identify sparseness by contiguous regions of zeros.  This was quite sometime ago so perhaps cp and tar have changed.

Sean
________________________________________
From: Theodore Tso [tytso@MIT.EDU]
Sent: Tuesday, June 28, 2011 1:14 PM
To: Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS]
Cc: linux-ext4@vger.kernel.org
Subject: Re: High CPU Utilization When Copying to Ext4

On Jun 28, 2011, at 2:37 PM, Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS] wrote:

> uname -a
> Linux sasr200-2.arc.nasa.gov 2.6.38.7-30.fc15.x86_64 #1 SMP Fri May 27 05:15:53 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
>
> There are about 10M files.  Many are small.  There are about 2M files that are sparse files.  It's hen the copy program gets to these files that the cpu usage gets very high.  There are no links of any kind.
>
> The copy program is written in Java, but uses the fiemap to get the logical address ranges that have actually been allocated.  It merges any contiguous logical address ranges when it reads and writes to the new file.

Fiemap?!?   What kind of copy algorithm are you using?

Why aren't you just doing a "read 10 megs from ext3",
"write 10 megs to ext4"?    How does fiemap figure into this?

-- Ted

