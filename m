From: Robert Mueller <robm@fastmail.fm>
Subject: Re: fallocate creating fragmented files
Date: Thu, 31 Jan 2013 09:49:36 +1100
Message-ID: <1359586176.29975.140661184693725.5AA32A9C@webmail.messagingengine.com>
References: <1359524809.5789.140661184325217.261ED7C8@webmail.messagingengine.com>
 <5108B833.6010004@redhat.com>
 <1359527713.648.140661184334613.06CF38D4@webmail.messagingengine.com>
 <510942C3.1070503@redhat.com> <20130130201412.GA32724@thunk.org>
 <1359580910.30605.140661184656041.31047642@webmail.messagingengine.com>
 <20130130214359.GD32724@thunk.org>
 <1359585611.5124.140661184685613.5C09C3AB@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Linux Ext4 mailing list <linux-ext4@vger.kernel.org>
To: Bron Gondwana <brong@fastmail.fm>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43018 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756016Ab3A3Wth (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 17:49:37 -0500
In-Reply-To: <1359585611.5124.140661184685613.5C09C3AB@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> It's the twoskip files that we're particularly concerned about.  Not
> so much that they fragment during use, that's kind of expected - but
> that a repack doesn't result in a single contiguous file.  Apart from
> the header, I can't see why it doesn't.

Well yes, this is ultimately what we're worried about, but we did some
digging and found that even just fallocating a file creates a very
fragmented file.

I think it's better to try and work out why just fallocating space for
files is creating such fragmented files, it's certainly a simpler test
case to try and get information on first.

Rob
