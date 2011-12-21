From: Junio C Hamano <gitster@pobox.com>
Subject: Re: [GIT PULL] ext4 bugfixes for 3.2-rc5
Date: Tue, 20 Dec 2011 21:41:12 -0800
Message-ID: <7v4nwuiirr.fsf@alter.siamese.dyndns.org>
References: <E1RauNd-0008W1-02@tytso-glaptop.cam.corp.google.com>
 <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:60900 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1LUFlQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Dec 2011 00:41:16 -0500
In-Reply-To: <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com> (Linus
 Torvalds's message of "Wed, 14 Dec 2011 18:50:07 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Dec 14, 2011 at 11:20 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>
>> There is a signed tag tytso-for-linus-20111214 covering these patches,
>> which fix a potential hang, crash (on big endian), and data corruption
>> bugs which show up when using fsx and/or Hugh's kernel compile/mm
>> torture test.
>
> Ok, since I build my own git versions, I have one that can pull signed
> tags and automatically verifies them and saves the signed tag
> information as part of the commit object.

Just a note. The new feature was broken when the pull has conflict that
needs to be resolved and concluded with "git commit". The version of git
from 'master' as of today should have a fix, but older ones forgot to
record the mergetag in the resulting commit object.
