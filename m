From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Question on fallocate/ftruncate sequence (and flags)
Date: Thu, 23 Jul 2009 19:33:04 -0400
Message-ID: <87f94c370907231633w75054378s5c49f20927fd61b0@mail.gmail.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
	 <4A64F37D.7020803@redhat.com>
	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>
	 <20090721215421.GM4231@webber.adilger.int>
	 <1248378517.8421.4.camel@bobble.smo.corp.google.com>
	 <4A68C9EC.4050301@redhat.com>
	 <20090723215357.GE4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Frank Mayhar <fmayhar@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:34330 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbZGWXdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 19:33:05 -0400
Received: by an-out-0708.google.com with SMTP id d40so1582113and.1
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 16:33:04 -0700 (PDT)
In-Reply-To: <20090723215357.GE4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>
>> I'm confused (again?) :). =A0I don't see FS_FALLOC_FL in the latest =
kernel
>> source, and ext2 (well, my ext2 anyway) can't do fallocate(). =A0Goo=
gle
>> (well, my google search) can't find it either. =A0Is this something =
in
>> your tree?
>
> I think I recall Google working on a patch for fallocate on ext2, but
> it was vetoed from upstream inclusion because we don't want to flog
> a dead horse.

Is that ext2 patch still around?  I'm doing some r&d via ext2 and it
might handy to have fallocate() for it.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Pap=
er -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html=
>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
