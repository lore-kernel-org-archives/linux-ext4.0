From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: one way to dmesg
Date: Wed, 4 Nov 2009 10:18:49 -0500
Message-ID: <87f94c370911040718k766d910fr23342c82d4632faa@mail.gmail.com>
References: <1257344804.2852.11.camel@zwerg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Alexey Fisher <bug-track@fisher-privat.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:39485 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbZKDPSp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Nov 2009 10:18:45 -0500
Received: by iwn10 with SMTP id 10so4993536iwn.4
        for <linux-ext4@vger.kernel.org>; Wed, 04 Nov 2009 07:18:50 -0800 (PST)
In-Reply-To: <1257344804.2852.11.camel@zwerg>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 4, 2009 at 9:26 AM, Alexey Fisher
<bug-track@fisher-privat.net> wrote:
> Hallo,
> this is sort of continue of discussion about unified way to mount fs
> readonly.
> I wont to know how about dmesg/printk. I see ext[234] produce different
> logs on mount even it use same code. I feel like i have some time to
> digg in. My target is easy to parse dmesg.

Patches for unified mount messages already exist.  Various versions
have been posted in the last couple months.

I don't know if they have been accepted yet or not.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Paper -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
