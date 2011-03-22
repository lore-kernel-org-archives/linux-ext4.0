From: Andrei Warkentin <andreiw@motorola.com>
Subject: Re: [RFC 4/5] MMC: Adjust unaligned write accesses.
Date: Tue, 22 Mar 2011 02:18:42 -0500
Message-ID: <AANLkTikZFYdhLLBLGp3=kc-UTZLQwUb-_sjYZ2nDd3Wc@mail.gmail.com>
References: <201103211527.45726.arnd@arndb.de>
	<8E9828F3-7533-4DC7-B2D1-EDFBF11BFCFD@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:53719 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab1CVHnZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Mar 2011 03:43:25 -0400
Received: from il93mgrg01.am.mot-mobility.com ([10.176.130.20])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id p2M7HDTr015954
	for <linux-ext4@vger.kernel.org>; Tue, 22 Mar 2011 03:17:14 -0400 (EDT)
Received: from mail-wy0-f170.google.com (mail-wy0-f170.google.com [74.125.82.170])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id p2M7HCN8015942
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Mar 2011 03:17:13 -0400 (EDT)
Received: by wyb34 with SMTP id 34so8709258wyb.15
        for <linux-ext4@vger.kernel.org>; Tue, 22 Mar 2011 00:18:42 -0700 (PDT)
In-Reply-To: <8E9828F3-7533-4DC7-B2D1-EDFBF11BFCFD@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2011 at 6:45 PM, Andreas Dilger <adilger@whamcloud.com> wrote:
> I was just looking at the test data. I wonder of this slowness might also be due to sync on ext4 using a barrier, and not on ext2/3?

Indeed. ext4 mounts by default with barrier=1...   I'll collect some
comparison data with various tunables. Sorry.

A
