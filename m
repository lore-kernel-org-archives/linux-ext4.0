From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4-fs error: bad header in inode: unexpected eh_depth
Date: Mon, 09 Mar 2009 16:14:05 -0500
Message-ID: <49B5869D.50503@redhat.com>
References: <20081206002838.GA16688@nineveh.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58578 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbZCIVOL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Mar 2009 17:14:11 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n29LE66U003202
	for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 17:14:06 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n29LE738011933
	for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 17:14:07 -0400
Received: from Liberator.lan (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n29LE6Ye010617
	for <linux-ext4@vger.kernel.org>; Mon, 9 Mar 2009 17:14:06 -0400
In-Reply-To: <20081206002838.GA16688@nineveh.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Joseph Fannin wrote:
> Hello,
> 
> I'm not sure I can reproduce this, but I've seen it twice in two days.
> I'm hoping someone could tell me a bit about what this means:
> 
> EXT4-fs error (device dm-1): ext4_ext_search_right: bad header in inode \
>  #29753858: unexpected eh_depth - magic f30a, entries 2, max 340(0), depth 1(2)
> 
> ... and then the journal aborts.  I ran fsck on the fs after the error
> both times.  After the second one:

Are you still seeing this?  if so, and you're willing to test the patch at:

http://bugzilla.kernel.org/show_bug.cgi?id=12821#c8

it may resolve it.

-Eric


