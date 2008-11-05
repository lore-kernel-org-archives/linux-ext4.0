From: Theodore Tso <tytso@mit.edu>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Wed, 5 Nov 2008 12:25:53 -0500
Message-ID: <20081105172553.GA29880@mit.edu>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com> <20081103134008.GE29102@mit.edu> <319012f0811050534i27b7dce1t8120b3a343844adc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roc Valles <vallesroc@gmail.com>, linux-ext4@vger.kernel.org
To: Cryptooctoploid <cryptooctoploid@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44091 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752449AbYKERZ4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 12:25:56 -0500
Content-Disposition: inline
In-Reply-To: <319012f0811050534i27b7dce1t8120b3a343844adc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cryptooctoploid,

Based on some reflection and further discussion on #ext4, I have a
theory which we need to try to prove/disprove that it may be related
to memory pressure combined with the delayed allocation code.

If you've already dismantled your ext4 setup, maybe you can't test
this, but it would be interesting to know mounting with the -o
nodelalloc makes the problem go away.  Also, how much memory do you
have in your system and is your system often under memory pressure?
(i.e., your system often uses swap, and where the amount of free
memory is often near the low water mark where it is trying to evict
memory either by dropping clean pages or writing dirty pages back to
the filesystem and/or swap).

						- Ted
