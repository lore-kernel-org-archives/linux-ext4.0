From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Sat, 26 Jan 2008 21:32:32 +0900
Message-ID: <2f11576a0801260432y4405d817p6ef4005d06189654@mail.gmail.com>
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <9Mo9w-7Ws-23@gated-at.bofh.it>
	 <9OdWm-7uN-25@gated-at.bofh.it> <9Oi9A-5EJ-3@gated-at.bofh.it>
	 <9OiMg-6IC-1@gated-at.bofh.it> <9OlqL-2xG-3@gated-at.bofh.it>
	 <9Orda-3ub-45@gated-at.bofh.it>
	 <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
	 <20080124230809.GA29120@does.not.exist>
	 <20080124234037.GJ15858@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@mit.edu>, "Adrian Bunk" <bunk@kernel.org>,
	"Bodo Eggert" <7eggert@gmx.de>,
	"Alan Cox" <alan@lxorguk.ukuu.org.uk>,
	"Andreas Dilger" <adilger@sun.com>, Valdis.Klet
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:9566 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYAZMce (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2008 07:32:34 -0500
Received: by py-out-1112.google.com with SMTP id u52so1529918pyb.10
        for <linux-ext4@vger.kernel.org>; Sat, 26 Jan 2008 04:32:33 -0800 (PST)
In-Reply-To: <20080124234037.GJ15858@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > And from a performance point of view letting applications voluntarily
> > free some memory is better even than starting to swap.
>
> Absolutely.

the mem_notify patch can realize "just before starting swapping" notification :)

to be honest, I don't know fs guys requirement.
if lacking feature of fs guys needed, I implement it with presure if
you tell me it.
