From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: data=journal busted
Date: Fri, 16 Feb 2007 14:50:22 -0800
Message-ID: <20070216145022.12e86c7d.randy.dunlap@oracle.com>
References: <20070215204445.411d2760.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:11797 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbXBPWyW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Feb 2007 17:54:22 -0500
In-Reply-To: <20070215204445.411d2760.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 15 Feb 2007 20:44:45 -0800 Andrew Morton wrote:

> 
> I have a report from a google person who just did some basic
> power-it-off-during-a-write testing on 2.6.20's ext3.  ordered-data is OK,
> but data=journal came back with crap in the file data.
> 
> Is anyone doing any formal recovery stress-testing?
> 
> I suspect we should resurrect and formalise my old
> make-the-disk-stop-accepting-writes-when-a-timer-goes-off thing.  It was
> very useful for stress-testing recovery.

Where is your make-troubles patch, please sir?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
