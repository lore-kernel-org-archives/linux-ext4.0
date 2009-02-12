From: Michael Rubin <mrubin@google.com>
Subject: Re: Options for migrating existing files on ext2 partitions to ext4
Date: Thu, 12 Feb 2009 00:01:21 -0800
Message-ID: <532480950902120001l213162a8k26d4499d25b4cede@mail.gmail.com>
References: <d5ca277e0902111218l1b568724l2557315d2945637a@mail.gmail.com>
	 <20090212072334.GB3199@webber.adilger.int>
	 <20090212075734.GA21074@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, Xiang Wang <xiangw@google.com>,
	linux-ext4@vger.kernel.org, ext4-team <ext4-team@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:9672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZBLIBY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2009 03:01:24 -0500
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id n1C81NUE018570
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 00:01:23 -0800
Received: from el-out-1112.google.com (elfb25.prod.google.com [10.126.179.25])
	by zps77.corp.google.com with ESMTP id n1C81Msw031893
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 00:01:22 -0800
Received: by el-out-1112.google.com with SMTP id b25so428252elf.16
        for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 00:01:21 -0800 (PST)
In-Reply-To: <20090212075734.GA21074@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 11, 2009 at 11:57 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> The plan was to hook the migrate interface with defrag so that after
> migrate we run a defrag on that that would move data blocks around.

Any data showing amount of time it takes to perform either the migrate
only or defrag-then-migrate operations on a disk both offline and
online?

mrubin
