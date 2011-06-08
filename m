From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Port xfstests 145, 161, 175, 176, 185?
Date: Wed, 08 Jun 2011 11:48:58 -0700
Message-ID: <4DEFC41A.9070701@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:43944 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1FHSta (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2011 14:49:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all!

During one of my reviews for the punch hole tests patch set it was 
mentioned that it would be helpful to take the xfstests 145, 161, 175, 
176, 185 and modify them such that they can run with out requiring the 
dmapi.  These tests contain some more interesting punch hole tests, but 
they dont normally run unless there is support for dmapi.

I did take a peek at them and I was thinking that if we decide to do 
this, we would probably need to do something like introduce a new set of 
source code that is similar to what is seen under the dmapi folder, but 
modified to use a generic interface instead of the dmapi libraries.  We 
could try to merge them into a single code path, but I think that may 
introduce more complexities than would be desirable.

I just wanted to get a general consensus of how many people would be 
interested in this idea.  Thx all!

Allison Henderson
