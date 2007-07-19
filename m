From: Tim Bird <tim.bird@am.sony.com>
Subject: Re: e2fsck bogus error report on orphan-list
Date: Thu, 19 Jul 2007 14:05:44 -0700
Message-ID: <469FD228.9070908@am.sony.com>
References: <873azkl7x4.wl%ryoichi@me.sony.co.jp> <20070719165510.GB14815@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Ryoichi.Kato@jp.sony.com, linux-ext4@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:47065 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757117AbXGSVB2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jul 2007 17:01:28 -0400
In-Reply-To: <20070719165510.GB14815@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Fri, Jul 20, 2007 at 12:39:19AM +0900, Ryoichi.Kato@jp.sony.com wrote:
>> The following sequence produces bogus e2fsck error report:
>> "/dev/XXX: Inodes that were part of a corrupted orphan linked list found."
>>
>>    1. Delete a file in an ext3 filesystem in early 1970
> 
> Dare I ask *why* the system clock was set in the 1970's?  Umm... don't
> do that.

It is not uncommon for embedded boards to omit battery backing
on the RTC, so they always boot with a bogus (start-of-epoch) time.

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================
