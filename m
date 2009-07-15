From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 1/2] HACK: ext3: mount fast even when recovering
Date: Wed, 15 Jul 2009 08:53:55 +0300
Message-ID: <4A5D6EF3.9050200@nokia.com>
References: <20090714140548.26116.2919.sendpatchset@ahunter-tower>	<20090714140554.26116.54779.sendpatchset@ahunter-tower> <20090714143449.cae624c8.akpm@linux-foundation.org>
Reply-To: Artem.Bityutskiy@nokia.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
	"sct@redhat.com" <sct@redhat.com>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:48361 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbZGOFyd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 01:54:33 -0400
In-Reply-To: <20090714143449.cae624c8.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton wrote:
> On Tue, 14 Jul 2009 17:05:54 +0300
> Adrian Hunter <adrian.hunter@nokia.com> wrote:
>=20
>> Speed up ext3 recovery mount time by not sync'ing the
>> block device.  Instead place all dirty buffers into the
>> I/O queue and add a write barrier.  This ensures that
>> no subsequent write will reach the disk before all the
>> recovery writes, but that we do not have to wait for the
>> I/O.
>>
>> Note that ext3 reads sectors the correct way: through the
>> buffer cache, so there is no risk of reading old metadata.
>=20
> hm.  The change seems reasonable to me.  afaict it leaves no timing
> windows during which another crash could muck things up.

In fact it was not very easy to persuade Adrian to submit
these patches to public because he thinks they are hacks and
not useful for anyone but us.

=46YI, we are trying to check how ext3 works on MMC, which
is very slow on random writes, and Adrian come up with
these patches to speed up ext3 recovery.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
