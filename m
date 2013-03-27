From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Eric Whitney's ext4 scaling data
Date: Tue, 26 Mar 2013 23:29:24 -0400
Message-ID: <20130327032924.GD5861@thunk.org>
References: <nsxhajyzu6n.fsf@closure.thunk.org>
 <alpine.LFD.2.00.1303261555140.2455@(none)>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56188 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab3C0D31 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 23:29:27 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303261555140.2455@(none)>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 26, 2013 at 04:06:47PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> It'll take me some time to process the results, but just one small
> nitpick is that in the mail server workload the reads and writes are
> not really representative for "just reads" or "just writes" as with
> the other tests since both interfere with each other. I am
> mentioning this just so that people do not misinterpret the results.

Yes, that's true.  The mail server workload is also one where the
benchmark results tend to be more variable, and so Eric has mentioned
in the past that he's had to run the benchmark several times to make
sure he's getting good, stable, numbers.

The nubmers are useful for seeing whether we've accidentally regressed
on scalability, but at least for previous results from Eric's
scalability testing, what I've found most interesting thing to look at
are the lockstat reports.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
