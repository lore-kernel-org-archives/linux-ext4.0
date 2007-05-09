From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Wed, 09 May 2007 10:21:44 -0500
Message-ID: <4641E708.1090109@redhat.com>
References: <20070503140804.463b20e1@naruto>	<463B4A1B.4070201@bull.net>	<20070507111952.7868bc1c@gara>	<4641BBB7.8020904@bull.net> <20070509085547.4785bf7d@gara> <4641E13D.906@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXEIPZ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 May 2007 11:25:28 -0400
In-Reply-To: <4641E13D.906@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Valerie Clement wrote:
> Jose R. Santos wrote:
>> I think this has more to do with the fact that I'm on a 32bit
>> architecture and there are still a couple places where blocks are
>> represented using "unsigned long".  I'm trying to get access to a 64=
bit
>> arch to confirm this.
>>
>> -JRS
>>
> Oh, I didn't catch that you use a 32-bit system.
> On 32-bit architectures, the page cache index size imposes a 16TB lim=
it=20
> on the filesystem size (with 4KB blocksize). So you need a 64-bit sys=
tem=20
> for your test.
>    Val=C3=A9rie

hm, the mount never should have gotten far enough to fail due to this,
should it have?

Jose, what exactly failed?  I see references to debugfs failing, but
also kernel logs...

Things like debugfs will have issues with very large block devices due
to maximum file size restrictions on 32-bit platforms, due to the page
cache issue Valerie mentions...  But trying to open it should give EFBI=
G
I'd think?

And mounting such a filesystem on a 32-bit system should also get
rejected early (and cleanly).

Jose, you mentioned that some blocks are still "unsigned long" on
32-bits... they shouldn't be, the LBD work should have fixed all those
long ago.  But there is still the 16TB page cache limit in force.

-Eric
