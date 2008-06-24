From: Mingming <cmm@us.ibm.com>
Subject: Re: Problem compiling 2.6.260rc6 with updated ext4-patch-queue
Date: Tue, 24 Jun 2008 15:34:45 -0700
Message-ID: <1214346885.27507.327.camel@BVR-FS.beaverton.ibm.com>
References: <3.0.6.32.20080624102659.02429f60@pop.west.cox.net>
	 <20080624221845.GK7639@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Gary Hawco <ghawco@cox.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:39058 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbYFXWeH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2008 18:34:07 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5OMY68f013678
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 18:34:06 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5OMY6Jo154984
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 16:34:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5OMY5Jh004319
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 16:34:06 -0600
In-Reply-To: <20080624221845.GK7639@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Tue, 2008-06-24 at 18:18 -0400, Theodore Tso wrote:
> On Tue, Jun 24, 2008 at 10:26:59AM +0000, Gary Hawco wrote:
> > Recently pulled and updated my ext4-patch-queue. Tried to compile
> > the 2.6.26-rc6 after it patched cleanly. During make received the
> > following error.
> 
> Hmm.... I just tested the latest commit on the ext4 patch queue
> (14581cb30), and it compiled just fine on 2.6.26-rc6.

Sorry! My bad. I accidently remove wrong patch when folding the bug
fixes to the parent patch. I did bring that patch back now Gary has
confirmed it compiles fine.

Mingming

