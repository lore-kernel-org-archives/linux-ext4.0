From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Updated ext4 quota design document
Date: Fri, 02 Jul 2010 11:41:37 +0400
Message-ID: <87hbkiqqj2.fsf@dmon-lap.sw.ru>
References: <E1OQg7e-0001mI-AB@closure.thunk.org>
	<20100622142047.GF3338@quack.suse.cz>
	<20100622200853.GD6843@thunk.org>
	<20100622202927.GA9413@quack.suse.cz>
	<20100622215200.GE6843@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56678 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab0GBHln (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Jul 2010 03:41:43 -0400
Received: by ewy23 with SMTP id 23so1023163ewy.19
        for <linux-ext4@vger.kernel.org>; Fri, 02 Jul 2010 00:41:41 -0700 (PDT)
In-Reply-To: <20100622215200.GE6843@thunk.org> (tytso@mit.edu's message of
	"Tue, 22 Jun 2010 17:52:00 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Tue, Jun 22, 2010 at 10:29:27PM +0200, Jan Kara wrote:
>>   With metadata which get journaled it should be quite easy. JBD already
>> must know before you go and modify buffer contents - that's why
>> journal_get_write_access and friends exist. It also makes sure that your
>> data cannot be modified from the moment the buffer enters commit upto the
>> moment the commit is finished. So you can use buffer commit hook to compute
>> and store block checksum safely.
>
> True, but we're also interested in making sure this feature can be
> used in the non-journal case as well....
Q:What is use case for that non-journal quota ?
A: ASAIU answer will "GFS chunkservers"
Are any chances that quota will be consistent with real space usage
after any failure? Currently difference may be huge.
BTW: ASAIU that it is not safe to use unclean fs in nojournal mode
without explicit e2fsck.  And ASAIU that is the reason why nojournal
users use replication or any other redundancy mechanism to protect
data and just throw away broken data after any failure on a single node.
