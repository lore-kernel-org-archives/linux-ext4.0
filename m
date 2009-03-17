From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Add support for data=alloc_on_commit mode
Date: Tue, 17 Mar 2009 14:58:59 +0530
Message-ID: <20090317092859.GA30636@skywalker>
References: <1237259998-12656-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58384 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZCQJ3S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Mar 2009 05:29:18 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id n2H9RVNR001004
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2009 20:27:31 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2H9TW3M466980
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2009 20:29:32 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2H9TEkT025707
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2009 20:29:14 +1100
Content-Disposition: inline
In-Reply-To: <1237259998-12656-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 16, 2009 at 11:19:58PM -0400, Theodore Ts'o wrote:
> Add an ext3 bug-for-bug compatible analogue for data=ordered mode.  In
> this mode, we force all delayed allocation blocks involved with the
> to-be-commited transaction to be allocated, and then flushed out to
> disk before the transaction is commited.
> 

Wouldn't this cause a deadlock ? We want to commit a transaction because
we don't have enough journal space (via journal_start) and now that would cause block
allocation which would do another journal_start()

-aneesh
