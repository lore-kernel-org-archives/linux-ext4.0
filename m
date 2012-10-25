From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4-fs error w/ external USB drive
Date: Thu, 25 Oct 2012 13:27:28 -0500
Message-ID: <50898490.20409@redhat.com>
References: <507C4BDA.20205@gmx.de> <20121019210723.GA4721@thunk.org> <5085923F.9050801@gmx.de> <20121024011128.GG28626@thunk.org> <5088260D.7080403@gmx.de> <20121024183505.GA6142@thunk.org> <50896B42.90606@gmx.de> <20121025182004.GA16257@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Theodore Ts'o" <tytso@mit.edu>,
	=?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
	linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759429Ab2JYS1k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2012 14:27:40 -0400
In-Reply-To: <20121025182004.GA16257@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/25/12 1:20 PM, Theodore Ts'o wrote:
> On Thu, Oct 25, 2012 at 06:39:30PM +0200, Toralf F=F6rster wrote:
>> After a lot of file operations (Gentoo emerging, kernel build, git
>> pulls, ...) I s2disk the system (that with the external USB drive)
>> yesterday, wake it up today, rebooted it -
>> and had to manually repair the file system, because the automatic fs=
ck
>> gave up.
>=20
> OK, I'm going to send another patch series which I'd hope you could
> test to see if reduces the rate at which this happens.
>=20
>> Nevertheless there's another Linux system I have (64bit RH EL,intern=
al
>> drive), where with kernel 3.5.4-1.el6.elrepo.x86_64 EXT4 errors occu=
rred.
>> I attached the whole appropriate section of /var/log/message.
>=20
> I don't have easy access to the RHEL kernel sources, and so I don't

Just FWIW, that's a 3rd party kernel, not something Red Hat
ships.  (see "elrepo")

-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
