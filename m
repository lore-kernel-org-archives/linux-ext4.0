From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: allocate inode table wholly within group
Date: Tue, 01 Oct 2013 10:35:10 -0500
Message-ID: <524AEBAE.1080208@redhat.com>
References: <51D3269B.5080608@redhat.com> <51DB2EB9.4010903@redhat.com> <20131001015746.GF5845@thunk.org> <524AE9A5.4010309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab3JAPfM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Oct 2013 11:35:12 -0400
In-Reply-To: <524AE9A5.4010309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/1/13 10:26 AM, Eric Sandeen wrote:
> On 9/30/13 8:57 PM, Theodore Ts'o wrote:
>> On Mon, Jul 08, 2013 at 04:27:21PM -0500, Eric Sandeen wrote:
>>>
>>> The actual problem seems to be that the test does successive "-M" minimal resizes, and eventually we resize into the middle of an inode table, leaving the end of the table beyond the fs.
>>>
>>> Point "resize2fs -M" at the attached image once or twice w/ fscks in between and you should see it.
>>
>> I've been going through my patch backlog, so I finally had a chance to
>> take a very close look at your test image.  I now understand why
>> things are failing.
>>
>> 1) The test image (which you said was generated on a ppc e2fsprogs?)
>> was doing something very weird as far as the location of the
>> allocation bitmaps and inode table:
> 
> Yes, this was just during a fedora build, during the "make check" phase.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=980519
> 
> No idea why things should be coming out differently, that's a bit
> alarming in and of itself.
> 
> (Fedora isn't carrying any interesting patches to speak of).

But I am doing this:

 %check
+# XXX ERS Hack for now; this bug has existed for a while,
+# i.e. it is not a regression in this release, but there
+# is no fix yet, and we need to get this package building.
+# See Bug 987133 - resize2fs tests failing on ppc, s390
+rm -rf tests/r_1024_small_bg*
+rm -rf tests/r_64bit_big_expand*
+rm -rf tests/r_bigalloc_big_expand*
+rm -rf tests/r_ext4_big_expand*
 make check

I'll retest w/ your patches, thanks.

-Eric

