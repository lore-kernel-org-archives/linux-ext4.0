From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 unlink performance
Date: Sat, 15 Nov 2008 17:08:09 -0600
Message-ID: <491F5659.7010206@redhat.com>
References: <20081113185712.GB11204@untroubled.org> <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu> <20081114041121.GB11746@untroubled.org> <20081114145914.GE25117@mit.edu> <20081115204423.GA4671@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57326 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYKOXIO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Nov 2008 18:08:14 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAFN8BTJ003228
	for <linux-ext4@vger.kernel.org>; Sat, 15 Nov 2008 18:08:11 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAFN8BIg003286
	for <linux-ext4@vger.kernel.org>; Sat, 15 Nov 2008 18:08:11 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mAFN89Ad015736
	for <linux-ext4@vger.kernel.org>; Sat, 15 Nov 2008 18:08:10 -0500
In-Reply-To: <20081115204423.GA4671@untroubled.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bruce Guenter wrote:
> On Fri, Nov 14, 2008 at 09:59:14AM -0500, Theodore Tso wrote:
>> This is beginning to perhaps sound like a layout problem of some kind.
> 
> To test this theory, I ran one test where I populated the filesystem
> with ext3 and then mounted as ext4 to do the unlinking.  This produced
> unlink times comparable with ext3.  That is, the degredation is occuring
> when the filesystem is populated, not when it is cleaned.

Maybe run the unlinking activity through seekwatcher* in both cases, to
see where the IO is happening.

(also, you're right w.r.t. lvm/dm; barriers don't pass and should get
disabled after the first attempt at a barrier write).

-Eric

*http://oss.oracle.com/~mason/seekwatcher/ (also packaged for fedora,
maybe other distros as well)
