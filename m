From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: High CPU Utilization When Copying to Ext4
Date: Wed, 29 Jun 2011 09:08:18 -0400
Message-ID: <50F503A1-6A16-41C4-9C27-0662063C7817@mit.edu>
References: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov>,<20110627030539.GF3064@thunk.org> <341DAA96EE3A8444B6E4657BE8A846EA4B3DA12708@NDJSSCC06.ndc.nasa.gov>,<F673734C-4ECE-40B2-B283-959027C34B06@mit.edu> <341DAA96EE3A8444B6E4657BE8A846EA4B3DA1270A@NDJSSCC06.ndc.nasa.gov>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS]"
	<sean.d.mccauliff@nasa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:53081 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481Ab1F2NIW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jun 2011 09:08:22 -0400
In-Reply-To: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA1270A@NDJSSCC06.ndc.nasa.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jun 28, 2011, at 4:20 PM, Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS] wrote:

> Last time I benchmarked cp and tar with the respective sparse file options they where extremely slow as they (claim) to identify sparseness by contiguous regions of zeros.  This was quite sometime ago so perhaps cp and tar have changed.

How many of your files are sparse?   If the source file is not sparse (which you can check by looking at st_blocks and comparing it to the st_size value), and skip calling fiemap in that case.

Also, how many times are you calling fiemap per file?   Are you calling once per block, or something silly like this?

(This is all of the details that should have been in your initial question, by the way....  we're not mind readers, you know.   Can you just send a copy of the key parts of your Java code?)

-- Ted

