From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: ext4 performance regression 2.6.27-stable versus 2.6.32 and
 later
Date: Mon, 2 Aug 2010 13:10:01 -0300
Message-ID: <20100802161001.GF32757@khazad-dum.debian.net>
References: <4C508A54.7070002@uni-konstanz.de>
 <AANLkTimh3eKc-M4xphq0djnSa=4W4hUf7KRf=icdF9Rk@mail.gmail.com>
 <4C56A240.1040506@uni-konstanz.de>
 <20100802160405.GE32757@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	linux <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Karsten Schaefer <karsten.schaefer@uni-konstanz.de>
To: Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36133 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533Ab0HBQKM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Aug 2010 12:10:12 -0400
Content-Disposition: inline
In-Reply-To: <20100802160405.GE32757@khazad-dum.debian.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 02 Aug 2010, Henrique de Moraes Holschuh wrote:
> On Mon, 02 Aug 2010, Kay Diederichs wrote:
> > Performance-wise, we tried mounting with barrier versus nobarrier (or
> > barrier=1 versus barrier=0) and re-did the 2.6.32+ benchmarks. It turned
> > out that the benchmark difference with and without barrier is less than
> > the variation between runs (which is much higher with 2.6.32+ than with
> > 2.6.27-stable), so the influence seems to be minor.
> 
> Did you check interactions with the IO scheduler?

Never mind, I reread your first message, and you did.  I apologise for the
noise.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
