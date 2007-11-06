From: Thierry Vignaud <tvignaud@mandriva.com>
Subject: Re: [PATCH e2fsprogs] - remove timestamps from .po files
Date: Tue, 06 Nov 2007 11:24:05 +0100
Message-ID: <m2sl3j1xkq.fsf@vador.mandriva.com>
References: <472F8792.6030808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from office-abk.mandriva.com ([84.55.162.90]:52286 "EHLO
	office.mandriva.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532AbXKFKtY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Nov 2007 05:49:24 -0500
In-Reply-To: <472F8792.6030808@redhat.com> (Eric Sandeen's message of "Mon\, 05 Nov 2007 15\:13\:54 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen <sandeen@redhat.com> writes:

> Another one that's been in RH/Fedora specfiles a while.
> Remove timestamps from .po files to avoid multilib conflicts.
> It ain't pretty but it works.

Sorry but that's insane.

Pos should not be updated on build.  They should only be updated by
upstream developers instead. This enable translators to catch up and
prevent such hackery

Your spec file should not contain "make -C po update-po" in the first
place.
This is a fedora bug, not an e2fsprogs one IMHO.

You introduced your own multi-lib in the first place...
