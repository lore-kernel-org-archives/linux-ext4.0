From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Replace iget with iget_locked in
	defrag-free-space-fragementation
Date: Tue, 05 Feb 2008 16:55:52 -0800
Message-ID: <1202259352.3935.16.camel@localhost.localdomain>
References: <E1JLLPj-0006dq-9C@closure.thunk.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Takashi Sato <t-sato@yk.jp.nec.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40312 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYBFAzv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Feb 2008 19:55:51 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m160tpgO004049
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 19:55:51 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m160tpLj221482
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 19:55:51 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m160toaS011623
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 19:55:50 -0500
In-Reply-To: <E1JLLPj-0006dq-9C@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2008-02-02 at 11:40 -0500, Theodore Ts'o wrote:
> We also have an issue where the read-only bind patches from Dave Hansen
> are making changes which conflict with the ext4 patch tree, which is
> making akpm very grumpy.  I'll try to take a look at this later in the
> weekend...
> 
> 						- Ted

BTW, Ted, could you clarify about this one? I am able to build the patch
queue on akpm's 2.6.24-mm1 tree with Dave Hansen's read-only bind
changes. Maybe I missed something.

Mingming
