From: Alexey Lyahkov <alexey.lyashkov@gmail.com>
Subject: Re: page eviction from the buddy cache
Date: Mon, 22 Apr 2013 15:14:55 +0300
Message-ID: <128E4C4E-555C-43B6-9BA4-7914CBAF5B62@gmail.com>
References: <51504A40.6020604@ya.ru> <20130327150743.GC14900@thunk.org> <alpine.LNX.2.00.1303271135420.29687@eggly.anvils> <3C8EEEF8-C1EB-4E3D-8DE6-198AB1BEA8C0@gmail.com> <515CD665.9000300@gmail.com> <239AD30A-2A31-4346-A4C7-8A6EB8247990@gmail.com> <51730619.3030204@fastmail.fm> <20130420235718.GA28789@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
	Will Huck <will.huckk@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Perepechko <anserper@ya.ru>, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, mgorman@suse.de
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40041 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab3DVMPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Apr 2013 08:15:05 -0400
Received: by mail-wi0-f171.google.com with SMTP id l13so4241420wie.16
        for <linux-ext4@vger.kernel.org>; Mon, 22 Apr 2013 05:15:03 -0700 (PDT)
In-Reply-To: <20130420235718.GA28789@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore,

May you provide more details about discussion and new interface?
someone from mm think we need to implement mark_acccessed_force() with avoiding is in LRU checks?
and move single page directly without waiting a LRU drain ?


On Apr 21, 2013, at 02:57, Theodore Ts'o wrote:

> On Sat, Apr 20, 2013 at 11:18:17PM +0200, Bernd Schubert wrote:
>> Alex, Andrew,
>> 
>> did you notice the patch Ted just sent?
>> ("ext4: mark all metadata I/O with REQ_META")
> 
> This patch was sent to fix another issue that was brought up at Linux
> Storage, Filesystem, and MM workshop.  I did bring up this issue with
> Mel Gorman while at LSF/MM, and as a result, tThe mm folks are going
> to look into making mark_page_accessed() do the right thing, or
> perhaps provide us with new interface.  The problem with forcing the
> page to be marked as activated is this would cause a TLB flush, which
> would be pointless since this these buddy bitmap pages aren't actually
> mapped in anywhere.
> 
> 						- Ted

