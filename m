From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/5] e2fsck: print a notice when we've started suppressing a problem code
Date: Mon, 19 Mar 2012 16:43:10 -0600
Message-ID: <2A65740A-4C62-4817-8C96-728C5EB75FA3@dilger.ca>
References: <1332100368-2683-1-git-send-email-tytso@mit.edu> <1332100368-2683-4-git-send-email-tytso@mit.edu> <1D4F4E78-7F63-406D-9D35-09F716E04C43@dilger.ca> <20120319002504.GC31682@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:23877 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab2CSWmT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2012 18:42:19 -0400
In-Reply-To: <20120319002504.GC31682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-18, at 6:25 PM, Ted Ts'o wrote:
> On Sun, Mar 18, 2012 at 05:17:20PM -0600, Andreas Dilger wrote:
>> 
>> Did a patch ever land to allow an interactive e2fsck run to set
>> a sticky answer (y/n) for a particular problem?  I know it has
>> been proposed several times.
> 
> It's been proposed but I don't think anyone has ever coded it.

There was the patch at: http://marc.info/?t=118597336000002&r=1&w=2
but I think the objection was that the "yes-to-all" and "no-to-all"
answers "A" and "O" were confusing for non-english speakers ("Oui",
for example).

However, I agree with the approach, and forcing a longer answer for
such a case like "yes-to-all" or "no-to-all" (or foreign equivalents)
is probably OK.

Cheers, Andreas





