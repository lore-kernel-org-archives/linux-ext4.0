From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Wed, 9 May 2007 10:29:40 -0500
Message-ID: <20070509102940.36493474@gara>
References: <20070503140804.463b20e1@naruto>
	<463B4A1B.4070201@bull.net>
	<20070507111952.7868bc1c@gara>
	<4641BBB7.8020904@bull.net>
	<20070509085547.4785bf7d@gara>
	<4641E13D.906@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:52404 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbXEIP3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 11:29:41 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l49FTf2T004490
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 11:29:41 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l49FTfOZ144208
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 09:29:41 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l49FTeoJ028524
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 09:29:40 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l49FTePb028497
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 09:29:40 -0600
In-Reply-To: <4641E13D.906@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 09 May 2007 16:57:01 +0200
Valerie Clement <valerie.clement@bull.net> wrote:

> Jose R. Santos wrote:
> > I think this has more to do with the fact that I'm on a 32bit
> > architecture and there are still a couple places where blocks are
> > represented using "unsigned long".  I'm trying to get access to a 6=
4bit
> > arch to confirm this.
> >=20
> > -JRS
> >=20
> Oh, I didn't catch that you use a 32-bit system.
> On 32-bit architectures, the page cache index size imposes a 16TB lim=
it=20
> on the filesystem size (with 4KB blocksize). So you need a 64-bit sys=
tem=20
> for your test.
>    Val=C3=A9rie

Thanks for the info.  Would the page cache limitation also restrict deb=
ugfs and dumpe2fs from reading information on a large filesystem?  Woul=
d a check need to be in place to limit the use of e2fsprog on 32bit arc=
hitectures using large block devices.

-JRS
