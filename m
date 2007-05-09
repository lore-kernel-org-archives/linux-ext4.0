From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Wed, 9 May 2007 08:55:47 -0500
Message-ID: <20070509085547.4785bf7d@gara>
References: <20070503140804.463b20e1@naruto>
	<463B4A1B.4070201@bull.net>
	<20070507111952.7868bc1c@gara>
	<4641BBB7.8020904@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46696 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbXEINzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 09:55:48 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l49DtlI7031674
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 09:55:47 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l49Dtlp2519932
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 09:55:47 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l49DtlCW032230
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 09:55:47 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l49DtkEE032221
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 09:55:47 -0400
In-Reply-To: <4641BBB7.8020904@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 09 May 2007 14:16:55 +0200
Valerie Clement <valerie.clement@bull.net> wrote:
> Hi Jose,
> I'm sorry to reply so late, I had a day off yesterday.
> I only tested the tools on an x86_64 system. Could it be an endianess=
 issue?
> On which platform do you run?
>     Val=C3=A9rie

Hi Valerie,

I think this has more to do with the fact that I'm on a 32bit
architecture and there are still a couple places where blocks are
represented using "unsigned long".  I'm trying to get access to a 64bit
arch to confirm this.

-JRS
