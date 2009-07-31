From: Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Fri, 31 Jul 2009 11:03:45 -0700
Message-ID: <532480950907311103h695cd79axa01905e33bd3838b@mail.gmail.com>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
	 <20090729181007.GC14105@mit.edu>
	 <20090730183053.GE9223@atrey.karlin.mff.cuni.cz>
	 <20090730203351.GB6833@mit.edu>
	 <1249063137.3917.8.camel@mingming-laptop>
	 <532480950907311103s422a70acx25c0ab9c56d1ae31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:1964 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZGaSDs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Jul 2009 14:03:48 -0400
Received: from zps75.corp.google.com (zps75.corp.google.com [172.25.146.75])
	by smtp-out.google.com with ESMTP id n6VI3mg5004937
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2009 11:03:49 -0700
Received: from bwz24 (bwz24.prod.google.com [10.188.26.24])
	by zps75.corp.google.com with ESMTP id n6VI3jpH002035
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2009 11:03:46 -0700
Received: by bwz24 with SMTP id 24so2117989bwz.14
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2009 11:03:45 -0700 (PDT)
In-Reply-To: <532480950907311103s422a70acx25c0ab9c56d1ae31@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 31, 2009 at 11:03 AM, Michael Rubin<mrubin@google.com> wrote:
> This will our expectations for DIO on ext4 also.

<sigh>

I meant "This will fulfill our expectations for DIO on ext4 also."

mrubin
