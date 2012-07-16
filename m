From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: Re: Question about extents.c/ext4_ext_punch_hole
Date: Mon, 16 Jul 2012 16:04:54 +0800
Message-ID: <5003CB26.9040401@gmail.com>
References: <5002BFAE.9030408@gmail.com> <alpine.LFD.2.00.1207160829280.3857@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48514 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2GPIFI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jul 2012 04:05:08 -0400
Received: by obbuo13 with SMTP id uo13so9153812obb.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2012 01:05:08 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1207160829280.3857@dhcp-1-248.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012=E5=B9=B407=E6=9C=8816=E6=97=A5 14:36, Luk=C3=A1=C5=A1 Czerner w=
rote:
> Indeed we're going to align
> the range to the block size, but that's because blocks in this range
> are going to be freed. Then, the rest of the range (non block
> aligned) is going to be zeroed manually. The reason is that we can
> not free those blocks, because it still contains valid data and we
> can not just leave it alone, since after the punch hole finishes
> we'll have to read zeroes from entire punched region.
>=20

Got it. Thanks, Lukas!
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
