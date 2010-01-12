From: jiayingz@google.com (Jiaying Zhang)
Subject: [PATCHv2 0/3] ext4: implement DIO read nolocking
Date: Tue, 12 Jan 2010 11:39:06 -0800 (PST)
Message-ID: <20100112193906.645A86E85C@peat.mtv.corp.google.com>
Cc: tytso@mit.edu, mrubin@google.com, akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:61558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab0ALTjo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 14:39:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

The following three patches are the updated patch set to allow 
ext4 DIO read without holding i_mutex lock. I re-partitioned 
the patches so the first patch contains only mechinical changes.
The fourth patch was dropped since it is only code cleanup to
avoid function declearation. This version of patches also contains
a couple of bug fixes for the previous one.

Jiaying
