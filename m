From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] - remove timestamps from .po files
Date: Tue, 06 Nov 2007 08:33:33 -0600
Message-ID: <47307B3D.2010708@redhat.com>
References: <472F8792.6030808@redhat.com> <m2sl3j1xkq.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Thierry Vignaud <tvignaud@mandriva.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbXKFOdi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2007 09:33:38 -0500
In-Reply-To: <m2sl3j1xkq.fsf@vador.mandriva.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thierry Vignaud wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
> 
>> Another one that's been in RH/Fedora specfiles a while.
>> Remove timestamps from .po files to avoid multilib conflicts.
>> It ain't pretty but it works.
> 
> Sorry but that's insane.
> 
> Pos should not be updated on build.  They should only be updated by
> upstream developers instead. This enable translators to catch up and
> prevent such hackery

Hrm, good point.

> Your spec file should not contain "make -C po update-po" in the first
> place.
> This is a fedora bug, not an e2fsprogs one IMHO.
> 
> You introduced your own multi-lib in the first place...

Apparently there was some issue with this, once upon a time, which
resulted in our rpms needing to update the po files... I guess I need to
do a bit more code archeology / research.  It looks like sct added this
when the pkg updated to 1.36, though there is no comment about why.

I inherited lots of history when I got e2fsprogs, so please forgive me
as I work through it.  :)

One question though, then - what is the existing timestamp removal
mechanism for, then?

-Eric
