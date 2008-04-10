From: Andreas Schwab <schwab@suse.de>
Subject: Re: ext4 compile error on m68k
Date: Thu, 10 Apr 2008 13:48:55 +0200
Message-ID: <je7if69bh4.fsf@sykes.suse.de>
References: <20080405102408.GB30987@cs181133002.pp.htv.fi>
	<Pine.LNX.4.64.0804051345180.7216@anakin>
	<20080410104059.GA23116@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Adrian Bunk <bunk@kernel.org>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	zippel@linux-m68k.org, linux-ext4@vger.kernel.org,
	linux-m68k@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbYDJLs7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2008 07:48:59 -0400
In-Reply-To: <20080410104059.GA23116@skywalker> (Aneesh Kumar K. V.'s message
	of "Thu\, 10 Apr 2008 16\:11\:32 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> But m68k doesn't want to use the GENERIC_FIND_NEXT_BIT. Can I request
> somebody knowledgeable about m68k to give a try in implementing
> generic_find_next_le_bit  equivalent on m68k ?

What's the exact semantic of generic_find_next_le_bit?  Why is it not
documented?

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
