From: Jim Meyering <jim@meyering.net>
Subject: Re: close /dev/urandom fd (e2fsprogs 1.40-WIP (7-Apr-2007))
Date: Sat, 16 Jun 2007 07:38:48 +0200
Message-ID: <87sl8sbgrb.fsf@rho.meyering.net>
References: <878xalc687.fsf@rho.meyering.net>
	<20070615220853.GI14911@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp3-g19.free.fr ([212.27.42.29]:32953 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbXFPFiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Jun 2007 01:38:50 -0400
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp3-g19.free.fr (Postfix) with ESMTP id E74D4389D
	for <linux-ext4@vger.kernel.org>; Sat, 16 Jun 2007 07:38:48 +0200 (CEST)
In-Reply-To: <20070615220853.GI14911@thunk.org> (Theodore Tso's message of "Fri\, 15 Jun 2007 18\:08\:54 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Jun 15, 2007 at 10:28:40PM +0200, Jim Meyering wrote:
>> The file descriptor opened on /dev/urandom can be closed sooner:
>
> Is there a reason why the caching of the open file descriptor for
> /dev/random is causing you problems?  Keeping it open was deliberate.

I saw it open at exit, missed the 'static' and thought it was an fd lea=
k.
D=C3=A9sol=C3=A9.
