From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Mon, 15 Aug 2011 12:56:17 +0400
Message-ID: <4E48DF31.4050603@msgid.tls.msk.ru>
References: <4E456436.8070107@msgid.tls.msk.ru> <1313251371-3672-1-git-send-email-tm@tao.ma> <4E4836A8.3080709@msgid.tls.msk.ru> <4E48390E.9050102@msgid.tls.msk.ru> <4E488625.609@tao.ma> <4E48D231.5060807@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:59446 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab1HOI4T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 04:56:19 -0400
In-Reply-To: <4E48D231.5060807@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

15.08.2011 12:00, Michael Tokarev wrote:
[....]

So, it looks like this (starting with cold cache):

1. rename the redologs and copy them over - this will
   make a hot copy of redologs
2. startup oracle - it will complain that the redologs aren't
   redologs, the header is corrupt
3. shut down oracle, start it up again - it will succeed.

If between 1 and 2 you'll issue sync(1) everything will work.
When shutting down, oracle calls fsync(), so that's like
sync(1) again.

If there will be some time between 1. and 2., everything
will work too.

Without dioread_nolock I can't trigger the problem no matter
how I tried.


A smaller test case.  I used redo1.odf file (one of the
redologs) as a test file, any will work.

 $ cp -p redo1.odf temp
 $ dd if=temp of=foo iflag=direct count=20

Now, first 512bytes of "foo" will contain all zeros, while
the beginning of redo1.odf is _not_ zeros.

Again, without aioread_nolock it works as expected.


And the most important note: without the patch there's no
data corruption like that.  But instead, there is the
lockup... ;)

Thank you,

/mjt
