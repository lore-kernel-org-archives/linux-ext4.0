From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Space Maps?
Date: Mon, 24 Nov 2014 16:12:51 +0000 (UTC)
Message-ID: <pan.2014.11.24.16.12.51@googlemail.com>
References: <pan.2014.11.24.12.43.51@googlemail.com>
	<20141124153336.GA10992@thunk.org> <547350F3.4050208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45187 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaKXQNG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Nov 2014 11:13:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1XswG7-0000AY-MB
	for linux-ext4@vger.kernel.org; Mon, 24 Nov 2014 17:13:03 +0100
Received: from p4ff580e3.dip0.t-ipconnect.de ([79.245.128.227])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2014 17:13:03 +0100
Received: from holger.hoffstaette by p4ff580e3.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2014 17:13:03 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 24 Nov 2014 09:38:27 -0600, Eric Sandeen wrote:

> On 11/24/14 9:33 AM, Theodore Ts'o wrote:
>> On Mon, Nov 24, 2014 at 12:43:51PM +0000, Holger Hoffst=C3=A4tte wro=
te:
>>>
>>> Cleaning out some old research papers I came again across the propo=
sal
>>> for "space maps" in ext4 [1]. What happened to that? Was it rejecte=
d
>>> due to too much risk or other technical reasons? The benefits sound
>>> appealing, so I was wondering if there's something fundamentally wr=
ong
>>> with the suggested approach.
>>=20
>> No one ever submitted patches.
>=20
> Was just checking that too. I'm always mystified by the folks who tak=
e the
> time to write & submit & present papers, but don't submit patches.

Thanks - that's all very sad. The author has a homepage at
http://saurabh.io/ so maybe someone with a sufficiently large army of
lawyers can contact him? I couldn't find any code right now either.

As for the patents - I'm outside the US and the paper explicitly mentio=
ns
using Linux' built-in RBTrees instead of AVL and a few othe minor
differences to ZFS, mostly relating to persisting the maps.

Holger

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
