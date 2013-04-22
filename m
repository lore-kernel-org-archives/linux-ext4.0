From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Weird resize2fs failures when mounting ext3 as ext4
Date: Sun, 21 Apr 2013 20:56:34 -0500
Message-ID: <517498D2.6040807@redhat.com>
References: <51229FF7.7090003@redhat.com> <20130421233057.GA5625@thunk.org> <51749486.20606@redhat.com> <20130422014756.GA4830@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab3DVB4i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Apr 2013 21:56:38 -0400
In-Reply-To: <20130422014756.GA4830@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/21/13 8:47 PM, Theodore Ts'o wrote:
> On Sun, Apr 21, 2013 at 08:38:14PM -0500, Eric Sandeen wrote:
>>> Also, here's a simplified repro that doesn't require LVM.  The bug was
>>> introduced in commit fb0a387dcdc, so it goes back to 2.6.32.
>>
>> Argh.  Karma!  Sorry about that, and thanks for taking a look.
> 
> No problem!  Could you do me a favor and package up the repro as a
> generic test case for xfstests?  I figure this would be a good thing
> to delegate to you, since you have a lot more experience creating
> tests for xfstests.

normally I'd say doing is a great way to learn, but I'm grateful
to you for fixing my regression, so - sure thing :)

Thanks,
-Eric
 
> 						- Ted
> 

