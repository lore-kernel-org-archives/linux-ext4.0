From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Filesystem testing
Date: Thu, 6 Feb 2014 10:45:46 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1402061040010.2248@localhost.localdomain>
References: <1391642427.40742.YahooMailNeo@web141002.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-625132164-1391679948=:2248"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mark Brown <ntdeveloper2002@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915AbaBFJpu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Feb 2014 04:45:50 -0500
In-Reply-To: <1391642427.40742.YahooMailNeo@web141002.mail.bf1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-625132164-1391679948=:2248
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 5 Feb 2014, Mark Brown wrote:

> Date: Wed, 5 Feb 2014 15:20:27 -0800 (PST)
> From: Mark Brown <ntdeveloper2002@yahoo.com>
> To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
> Subject: Filesystem testing
> 
> Hello all,
> What are the most common testing tools used for stress testing ext4(or any file system..), and making sure the data (and metadata) that was written is correctly read back, operations that were done(whether usual R/W, but also others like truncate, stat,link, f* operations etc) did not cause problems or corruptions, do fscks if needed etc?
> 
> Also, are there tools that can cause aborts underneath the file system, basically something in the mid layer that randomly drops IOs or something along those lines?

Yes, there is device mapper target dm-flakey (see
Documentation/device-mapper/dm-flakey.txt in linux kernel sources).
Xfstests does have infrastructure to use this target in its tests
(see tests 311, 321 and 322).

-Lukas

> 
> I am looking for tests which can fully stress the system exercising the file system and also check for corruption. 
> 
> As an aside, I looked at xfstests, from what I could gather, it was started only for xfs, but there is ongoing work to make it work with ext4(and thus other posix FS?). If someone can point me to the documentation for xfstests and what it does, that would help. I could not find much.
> 
> Thanks in advance.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-625132164-1391679948=:2248--
