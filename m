From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Fri, 5 Jun 2009 18:51:31 +0200
Message-ID: <ac3eb2510906050951o200c3aeex56dcb32bf29d0607@mail.gmail.com>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com>
	<4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com>
	<4A294B15.9070209@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Aioanei Rares <krnl.list@gmail.com>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:65186 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZFEQvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 12:51:50 -0400
In-Reply-To: <4A294B15.9070209@tuffmail.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 5, 2009 at 18:43, Alan Jenkins<alan-jenkins@tuffmail.co.uk>=
 wrote:

> If I remove the corrupted file and copy a "known good" copy into it's=
 place,
> then the corruption doesn't happen. =C2=A0I've verified this a couple=
 of times.
> =C2=A0The corruption only occurs if the file was created by "locale-g=
en".

Does it use things like: fallocate()?

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
