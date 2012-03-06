From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Some interesting input from a flash manufacturer
Date: Mon, 5 Mar 2012 20:12:26 -0500
Message-ID: <CAGpXXZ+SsUQZUVi4zFqpV6P3SfcTDKzW9t1aVY3iBH_-0VOwcg@mail.gmail.com>
References: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
 <4F5135F0.6090100@redhat.com> <20120302231131.GE22215@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37110 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab2CFBM5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2012 20:12:57 -0500
Received: by iagz16 with SMTP id z16so6305274iag.19
        for <linux-ext4@vger.kernel.org>; Mon, 05 Mar 2012 17:12:56 -0800 (PST)
In-Reply-To: <20120302231131.GE22215@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 2, 2012 at 6:11 PM, Ted Ts'o <tytso@mit.edu> wrote:
> I'm even aware of one implementation which remembers the trim
> request while the system is powered on, but since it doesn't
> (necessarily) write the trim information to stable store, you could
> trim the block, read the block and get zeros, then take a power
> failure, and afterwards, read the block and get the previous contents.
>
> As far as I know, the Trim spec allows all of this.

It's been a while since I read the spec, but the read operation above
changes the rules I believe.

That is if the SSD advertizes itself as having deterministic reads
after a trim, that read should lock in the values, and a power cycle
should not change that as I understood the spec.

Otherwise what you describe would be a non-deterministic read.  That
is also allowed, but the drive would need to advertise itself as
non-deterministic after trim.

Greg
