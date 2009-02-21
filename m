From: Michael Rubin <mrubin@google.com>
Subject: Re: fsck errors encountered when applying patch "ext4: fix BUG when
	calling ext4_error with locked block group"
Date: Fri, 20 Feb 2009 17:37:35 -0800
Message-ID: <532480950902201737j5162125teea57eedbd01873f@mail.gmail.com>
References: <d5ca277e0902201531g6e32691cweda3fd8f6d1dbbff@mail.gmail.com>
	 <20090221012908.GC12966@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Xiang Wang <xiangw@google.com>, linux-ext4@vger.kernel.org,
	aneesh.kumar@linux.vnet.ibm.com,
	Curt Wohlgemuth <curtw@google.com>,
	Chad Talbott <ctalbott@google.com>,
	Frank Mayhar <fmayhar@google.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:17098 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbZBUBhl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Feb 2009 20:37:41 -0500
Received: from zps75.corp.google.com (zps75.corp.google.com [172.25.146.75])
	by smtp-out.google.com with ESMTP id n1L1bcPP025078
	for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2009 17:37:39 -0800
Received: from el-out-1112.google.com (elfj27.prod.google.com [10.126.186.27])
	by zps75.corp.google.com with ESMTP id n1L1bapU017620
	for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2009 17:37:37 -0800
Received: by el-out-1112.google.com with SMTP id j27so563772elf.15
        for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2009 17:37:36 -0800 (PST)
In-Reply-To: <20090221012908.GC12966@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 20, 2009 at 5:29 PM, Theodore Tso <tytso@mit.edu> wrote:
> One of the downsides of trying to backport a lot of changes to a
> kernel version as old as 2.6.26 is that you miss changes like this.
> You might want to think about leapfrogging to a newer kernel at some
> point....

We know. Our qualifying process is not the most light weight and the
kernel moves fast. Normally we take a snapshot and qualify it, trying
to take upstream patches when we can and then also publishing bugs we
find. The problem is that with ext4 still undergoing active dev we
want to be able to keep our ext4 portion of the tree as up to date as
possible.

I admit it's a bit of a balancing act.

Hopefully we won't be causing a lot of undue burden on this list.

Thanks for this.

Michael Rubin
