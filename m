From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: ext3 duplicate entries with readdir
Date: Tue, 3 Mar 2009 15:54:02 -0500
Message-ID: <170fa0d20903031254l7070294cwfa45ffdcc63b24d9@mail.gmail.com>
References: <20090303200526.GA20236@ub>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:16769 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZCCUyF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Mar 2009 15:54:05 -0500
In-Reply-To: <20090303200526.GA20236@ub>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 3, 2009 at 3:05 PM, Andries E. Brouwer
<Andries.Brouwer@cwi.nl> wrote:
> In a largish directory (21292 files) a scan using ext3 readdir
> found 21293 files, returning one entry twice.
>
> Google "ext3 readdir twice" gives me a handful of identical complaints.
> I see reports from 2002-2008.
> So, this is an old and well-known symptom but seemingly still not fixed,
> at least not in the kernel on this machine here.
> This report is for Fedora release 8 (Werewolf) with kernel 2.6.24.5.
>
> A 2002 post says "This is unfortunate, but the chances of our hitting
> this failure are relatively small".
>
> In http://www.redhat.com/archives/ext3-users/2008-August/msg00009.html
> tytso seems to understand what happens: a hash collision.
> But has this been fixed in the current tree?

Yes, it has been fixed, please see the following git commits:
6a897cf447a83c9c3fd1b85a1e525c02d6eada7d
8c9fa93d51123c5540762b1a9e1919d6f9c4af7c

Mike
