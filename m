From: Solofo.Ramangalahy@bull.net
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Wed, 5 Nov 2008 21:09:46 +0100
Message-ID: <18705.64906.497902.219660@frecb006361.adech.frec.bull.fr>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
	<20081103134008.GE29102@mit.edu>
	<319012f0811030734s6d14b2b3t13c32a41ac48e852@mail.gmail.com>
	<20081103165144.6514f003@starbug.prg01.itonis.net>
	<18705.63392.489856.682976@frecb006361.adech.frec.bull.fr>
	<20081105195713.GB9266@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Solofo.Ramangalahy@bull.net,
	Jindrich Makovicka <makovick@gmail.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52605 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbYKEUJy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 15:09:54 -0500
In-Reply-To: <20081105195713.GB9266@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso writes:
 > How much memory did you have on your system,

128MB (it is under kvm).

 > and how much memory was
 > free when you ran the test case?

I don't know.

 > The next question is whether the problem is more easily triggerred
 > when under memory pressure.

I was currently testing other kernels, but, right, I will retest with more memory.

-- 
solofo

