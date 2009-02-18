From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Subject: Re: next-20090206: deadlock on ext4
Date: Wed, 18 Feb 2009 11:12:18 +0100
Message-ID: <20090218101218.GR19388@charite.de>
References: <a4423d670902060935y59e540beta417144935416560@mail.gmail.com> <498C7671.1050309@redhat.com> <a4423d670902061004i424817e1vd699a61e335f010a@mail.gmail.com> <498C9876.3060208@redhat.com> <a4423d670902090401k716d054eo25640aa2207beca7@mail.gmail.com> <4995F27E.3070401@redhat.com> <a4423d670902180156yd293319na51f91c6651e076c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ausfall.charite.de ([193.175.70.131]:47986 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZBRKSG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Feb 2009 05:18:06 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail-ausfall.charite.de (Postfix) with ESMTP id E468E3DB5B
	for <linux-ext4@vger.kernel.org>; Wed, 18 Feb 2009 11:12:18 +0100 (CET)
Received: from mail-ausfall.charite.de ([127.0.0.1])
	by localhost (mail-ausfall.charite.de [127.0.0.1]) (amavisd-new, port 10025)
	with ESMTP id 4M6vk6+iCtVa for <linux-ext4@vger.kernel.org>;
	Wed, 18 Feb 2009 11:12:18 +0100 (CET)
Received: from postamt.charite.de (postamt.charite.de [141.42.4.250])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail-ausfall.charite.de (Postfix) with ESMTPS
	for <linux-ext4@vger.kernel.org>; Wed, 18 Feb 2009 11:12:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <a4423d670902180156yd293319na51f91c6651e076c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Yes, it works, I can not reproduce the bug on
> 2.6.29-rc5-00122-g5955c7a which contains 2acf2c261b82
> "ext4: Implement range_cyclic in ext4_da_writepages instead of
> write_cache_pages"

Will there be a backport for 2.6.28.x ?
I'm suffering here.

--=20
Ralf Hildebrandt                                Ralf.Hildebrandt@charit=
e.de
Charite - Universit=C3=A4tsmedizin Berlin            Tel.  +49 (0)30-45=
0 570-155
Gesch=C3=A4ftsbereich IT | Abt. Netzwerk             Fax.  +49 (0)30-45=
0 570-962
Hindenburgdamm 30 | 12200 Berlin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
